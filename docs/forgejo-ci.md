# Forgejo CI

CI/CD for this app runs on **Forgejo Actions** with a **self-hosted, rootless-Podman runner**.
The runner lives on a workstation (not the VPS) — it polls Forgejo over an outbound
connection, so it adds zero load to the server hosting Forgejo and the API.

Two workflows:

| Workflow                       | Trigger                       | Does                                                        |
| ------------------------------ | ----------------------------- | ----------------------------------------------------------- |
| `.forgejo/workflows/ci.yml`    | push / PR to `main` or `dev`  | `flutter pub get` → format check → codegen → analyze → test |
| `.forgejo/workflows/release.yml` | push a tag matching `v*`     | builds a **signed AAB**, uploads it as a downloadable artifact |

Releases are **not** auto-published to Google Play — download the artifact and upload it
by hand. (Automating that is a later add-on: fastlane `supply` + a Play service-account secret.)

---

## 1. Set up the rootless Podman runner

Run these on the machine that will execute builds (Fedora workstation). Flutter Android
builds are RAM/CPU heavy — a workstation handles them far better than a small VPS.

### 1a. Enable the rootless Podman socket

```sh
systemctl --user enable --now podman.socket
# socket lands at: unix:///run/user/1000/podman/podman.sock
```

Optional — `loginctl enable-linger <user>` lets the user socket (and the runner service
from step 1e) start at boot and keep running when you're fully logged out. **Without
linger** (the default), both run only while you have an active login session — fine for a
workstation you build from directly; just know CI goes offline when you log out (queued
jobs stay pending and run once you log back in).

```sh
loginctl enable-linger <user>   # only if you want unattended, boot-time operation
```

### 1b. Install forgejo-runner

Download the latest binary from <https://code.forgejo.org/forgejo/runner/releases>
(pick `linux-amd64`), then install it into your per-user bin (no `sudo` — keeps the
whole setup rootless; `~/.local/bin` is already on `PATH` on Fedora):

```sh
mkdir -p ~/.local/bin
install -m755 forgejo-runner-*-linux-amd64 ~/.local/bin/forgejo-runner
forgejo-runner --version
```

### 1c. Generate the config file

Keep the runner's state in a stable working directory so it doesn't depend on where you
happen to `cd`, then generate the default config there:

```sh
mkdir -p ~/.local/share/forgejo-runner
cd ~/.local/share/forgejo-runner
forgejo-runner generate-config > config.yml
```

> Forgejo runner v12 (Forgejo 15) is **fully declarative** — there is no `register`
> command or `.runner` file anymore. The instance connection, labels, and Podman socket
> all live in `config.yml`.

### 1d. Configure labels, Podman, and the connection

In Forgejo: **(user) Settings → Actions → Runners → Create new runner**. Give it a name
(e.g. your hostname) and Forgejo shows a **UUID** and a **Token** — copy both. The UUID
also stays visible in the Runners list; the Token is shown only once.

Then set these keys in `config.yml`:

```yaml
runner:
  labels:
    # The `docker` label matches `runs-on: docker` in both workflows. The catthehacker
    # image ships Node.js, required by the JS actions (checkout, setup-java, upload-artifact).
    - docker:docker://ghcr.io/catthehacker/ubuntu:act-22.04

container:
  # Talk to rootless Podman instead of Docker:
  docker_host: "unix:///run/user/1000/podman/podman.sock"

server:
  connections:
    forgejo:
      url: https://git.fiatcode.dev/
      uuid: <RUNNER_UUID>     # from the Create-new-runner dialog / Runners list
      token: <RUNNER_TOKEN>   # shown once; keep this file private
```

Because the file now holds a secret, lock it down:

```sh
chmod 600 ~/.local/share/forgejo-runner/config.yml
```

### 1e. Run the runner as a systemd user service

Run it under systemd so it survives logout/reboot and restarts on failure. Create
`~/.config/systemd/user/forgejo-runner.service`:

```ini
[Unit]
Description=Forgejo Actions runner (rootless Podman)
Wants=podman.socket
After=podman.socket network-online.target

[Service]
Type=simple
WorkingDirectory=%h/.local/share/forgejo-runner
ExecStart=%h/.local/bin/forgejo-runner daemon --config config.yml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

Then enable and start it:

```sh
systemctl --user daemon-reload
systemctl --user enable --now forgejo-runner.service
systemctl --user status forgejo-runner.service
```

You should see `Active: active (running)` and a `declared successfully` log line.

**Availability without linger:** `WantedBy=default.target` ties the service to your user
session — it starts when you log in and stops when you log out of all sessions. So the
runner is online whenever you're logged in, and offline (jobs queue as pending) when you
are not. Enable linger in step 1a if you want it online from boot, unattended.

To sanity-check the config without systemd, you can also run it in the foreground once:
`forgejo-runner daemon --config config.yml`.

---

## 2. Forgejo server prerequisites

In your Forgejo `app.ini`:

```ini
[actions]
ENABLED = true
```

The release workflow uploads an artifact, which needs the artifacts feature enabled.
`actions/upload-artifact@v3` is used here for broad compatibility; on Forgejo **v7.0+**
you can bump it to `@v4`.

> **Action resolution:** Forgejo resolves bare `actions/*` references from
> `code.forgejo.org` by default. Third-party actions therefore use **full GitHub URLs**
> in the workflows (e.g. `https://github.com/subosito/flutter-action@v2`) so they resolve
> regardless of your instance's default registry.

---

## 3. Required Actions secrets and variables

Only the keystore material is sensitive, so it goes in **Secrets**. The API host/scheme
and Sentry DSN ship inside the public APK anyway, so they live in **Variables**.

**Secrets** — *Repo → Settings → Actions → Secrets* (`${{ secrets.* }}`):

| Secret              | What                                                            |
| ------------------- | -------------------------------------------------------------- |
| `KEYSTORE_BASE64`   | Base64 of your upload keystore: `base64 -w0 upload-keystore.jks` |
| `KEYSTORE_PASSWORD` | Keystore store password                                        |
| `KEY_ALIAS`         | Key alias                                                      |
| `KEY_PASSWORD`      | Key password                                                   |

**Variables** — *Repo → Settings → Actions → Variables* (`${{ vars.* }}`):

| Variable           | Value                                  |
| ------------------ | -------------------------------------- |
| `QUOTE_API_SCHEME` | `https`                                |
| `QUOTE_API_HOST`   | `api.fiatcode.dev`                     |
| `SENTRY_DSN`       | Sentry DSN for release crash reporting |

The signing config in `android/app/build.gradle` reads `KEYSTORE_PATH` /
`KEYSTORE_PASSWORD` / `KEY_ALIAS` / `KEY_PASSWORD` from the environment when present,
and falls back to a local `android/keystore.properties` for local release builds.

---

## 4. Cutting a release

The git tag is the single source of truth for the version. Use Flutter's
`<name>+<code>` version string, prefixed with `v`:

```sh
git tag v1.2.29+29   # versionName 1.2.29, versionCode 29
git push origin v1.2.29+29
```

`release.yml` parses the tag into `--build-name=1.2.29` and `--build-number=29`, builds a
signed AAB, and publishes it as the artifact `kuwot-v1.2.29+29-aab`. Download it from the
run page and upload to the Google Play console.

> **Google Play requires a strictly increasing `versionCode`** (the `+N`). It must exceed
> the highest already on Play — currently **28** (versionName `1.2.28`), so the next
> release is **`v1.2.29+29`**. The workflow fails fast if a tag omits the `+code`.
> `pubspec.yaml` mirrors the live version (`1.2.28+28`) for local builds; the tag
> overrides it for CI releases.
