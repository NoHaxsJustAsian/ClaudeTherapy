### Configure the API Key

1. **Locate the `Secrets.plist` file**:
   - The `Secrets.plist` file is located in the `ClaudeTherapy/` directory in your project structure.

2. **Update the file**:
   - Open the `Secrets.plist` file and replace the placeholder with your actual Anthropic API key:
     ```xml
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
     <dict>
         <key>AnthropicAPIKey</key>
         <string>YOUR_API_KEY_HERE</string>
     </dict>
     </plist>
     ```
