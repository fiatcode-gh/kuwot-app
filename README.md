# Kuwot
Daily quote app with beautiful pics from [Unsplash](https://unsplash.com/), built with Flutter 🚀

# Environment Variables
## Visual Studio Code
Add or modify `.vscode/launch.json`, fills out the required environment variables.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "kuwot-app (dev)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=QUOTE_API_SCHEME=http",
                "--dart-define=QUOTE_API_HOST=10.0.2.2",
                "--dart-define=QUOTE_API_PORT=8080",
                "--dart-define=AUTH_PUBLIC_KEY=keep_looking",
                "--dart-define=SENTRY_DSN=optional"
            ]
        }
    ]
}
```

## Android Studio (or IntelliJ)
Add or modify `run/debug configurations`, add the following environment variables to the `Additional run args` field.

```
--dart-define=QUOTE_API_SCHEME=http
--dart-define=QUOTE_API_HOST=10.0.2.2
--dart-define=QUOTE_API_PORT=8080
--dart-define=AUTH_PUBLIC_KEY=keep_looking
--dart-define=SENTRY_DSN=optional
```
