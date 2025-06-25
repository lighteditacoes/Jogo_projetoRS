# AI Coding Assistant Plugin for Godot

A powerful AI-powered coding assistant plugin for Godot Engine that provides real-time chat, code suggestions, and code generation using free AI APIs.

## Features

### 🤖 AI Chat Interface
- Real-time chat with AI for coding questions and assistance
- Context-aware responses based on your current code
- Support for multiple AI providers

### 💡 Code Suggestions & Completion
- Real-time code suggestions while typing
- Context-aware completions based on your current script
- Smart suggestions for variables, functions, and Godot API

### 🔧 Code Generation
- Generate code snippets, classes, and functions
- Diff viewer to review changes before applying
- Quick action buttons for common code templates
- Support for GDScript-specific patterns

### 🔌 Multiple AI Provider Support
- **Google Gemini API** (Free tier available)
- **Hugging Face** (Free inference API)
- **Cohere** (Free tier available)

### 🎯 Advanced Features
- Code explanation and analysis
- Code improvement suggestions
- Bug detection and fixes
- Real-time diff viewing with accept/reject options

### 🎨 Resizable UI Interface
- **Flexible Layout**: Drag splitters to resize chat and code sections
- **Collapsible Sections**: Hide/show API settings and quick actions
- **Persistent Layout**: Your preferred layout is saved between sessions
- **Responsive Design**: Adapts to different dock sizes and screen resolutions

### 📋 Enhanced Selection & Copy Features
- **Context Menus**: Right-click for copy, save, and editing options
- **Text Selection**: Select and copy any part of chat or code
- **Quick Actions**: One-click buttons for copy, save, and clear
- **Keyboard Shortcuts**: Ctrl+C, Ctrl+S, Ctrl+L, and more
- **File Export**: Save chat history and code to files

### 📦 Flexible Boxes for Reading & Writing
- **Enhanced Chat Box**: Markdown support, word wrap toggle, timestamps
- **Enhanced Code Box**: Line numbers, full editing, horizontal scrolling
- **View Controls**: Toggle word wrap (↩/→) and line numbers (#/∅)
- **Larger Minimum Sizes**: Better readability with 150px+ chat, 120px+ code
- **Persistent Preferences**: View settings saved between sessions

## Installation

### Method 1: Manual Installation

1. Download or clone this repository
2. Copy the entire plugin folder to your Godot project's `addons/` directory:
   ```
   your_project/
   └── addons/
       └── ai_coding_assistant/
           ├── plugin.cfg
           ├── plugin.gd
           ├── ai_assistant_dock.gd
           ├── ai_api_manager.gd
           ├── code_analyzer.gd
           ├── diff_viewer.gd
           ├── settings_dialog.gd
           └── README.md
   ```

3. Enable the plugin in Project Settings > Plugins > AI Coding Assistant

### Method 2: Asset Library (Coming Soon)
The plugin will be available through Godot's Asset Library.

## Setup & Configuration

### 1. Get API Keys

#### Google Gemini API (Recommended - Free)
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key for use in the plugin

#### Hugging Face (Free)
1. Sign up at [Hugging Face](https://huggingface.co/)
2. Go to Settings > Access Tokens
3. Create a new token with "Read" permissions

#### Cohere (Free Tier)
1. Sign up at [Cohere](https://cohere.ai/)
2. Go to API Keys section
3. Copy your API key

### 2. Configure the Plugin

1. After enabling the plugin, you'll see the "AI Assistant" dock on the left side
2. In the API Settings section:
   - Select your preferred provider (Gemini recommended for beginners)
   - Enter your API key
   - The settings are automatically saved

### 3. Advanced Settings (Optional)

Click the settings button to access advanced options:
- **Temperature**: Controls creativity (0.0 = deterministic, 1.0 = very creative)
- **Max Tokens**: Maximum response length
- **Auto-suggestions**: Enable real-time code suggestions
- **Save History**: Keep chat history between sessions

## Usage

### Basic Chat
1. Type your coding question in the input field
2. Press Enter or click "Send"
3. The AI will respond with helpful information

Example questions:
- "How do I create a player movement script in Godot?"
- "Explain this code: [paste your code]"
- "What's the best way to handle collisions in Godot?"

### Code Generation
1. Ask the AI to generate code: "Create a health system for my player"
2. The generated code will appear in the "Generated Code" section
3. Review the code and click "Apply to Script" to insert it at your cursor

### Quick Actions
Use the quick action buttons for common templates:
- **Generate Class Template**: Creates a basic GDScript class
- **Generate Singleton**: Creates an autoload script template
- **Generate UI Controller**: Creates a UI interaction script

### Code Analysis
1. Select code in your script editor
2. Click "Explain" to get a detailed explanation
3. Click "Improve" to get optimization suggestions

### Diff Viewer
When generating code that modifies existing code:
1. The diff viewer will show changes side-by-side
2. Review additions (green), deletions (red), and modifications (yellow)
3. Accept, reject, or edit the changes before applying

### Resizable Interface
Customize the dock layout to fit your workflow:
1. **Resize Sections**: Drag the horizontal divider between chat and code sections
2. **Collapse Sections**: Click ▼/▶ buttons to hide/show API settings or quick actions
3. **Dock Resizing**: Resize the entire dock by dragging its edges
4. **Layout Memory**: Your preferred layout is automatically saved and restored

### Enhanced Selection & Copy
Work more efficiently with flexible text handling:
1. **Right-click Menus**: Access copy, save, and editing options
2. **Text Selection**: Select any text in chat or code areas
3. **Quick Buttons**: Use 🗑 (clear), 📋 (copy), 💾 (save) buttons
4. **Keyboard Shortcuts**: Ctrl+C (copy), Ctrl+S (save), Ctrl+L (clear chat)
5. **File Export**: Save conversations and code to your file system

### Flexible Boxes for Optimal Experience
Customize text display and editing for better productivity:
1. **Chat Word Wrap**: Click ↩/→ to toggle text wrapping for long messages
2. **Code Line Numbers**: Click #/∅ to show/hide line numbers for code reference
3. **Enhanced Markdown**: Enjoy **bold**, *italic*, `code`, and code blocks in chat
4. **Full Code Editing**: Edit generated code directly with multiple cursors and selection
5. **Larger Viewing Areas**: Bigger minimum sizes for better readability

## Tips for Best Results

### Writing Good Prompts
- Be specific about what you want
- Mention it's for Godot/GDScript
- Provide context about your game/project
- Include relevant code snippets when asking for help

### Examples of Good Prompts
```
"Create a GDScript inventory system with add, remove, and display functions"
"How do I optimize this movement code for better performance? [paste code]"
"Generate a state machine for enemy AI in Godot"
"Explain how signals work in this code: [paste code]"
```

### API Usage Tips
- **Gemini**: Best for general coding help and explanations
- **Hugging Face**: Good for code completion and small snippets
- **Cohere**: Excellent for code analysis and improvements

## Troubleshooting

### Common Issues

**"API key not set" error**
- Make sure you've entered your API key in the settings
- Verify the key is correct and has proper permissions

**"HTTP Error: 401" or "HTTP Error: 403"**
- Your API key is invalid or expired
- Check if you've exceeded your free tier limits

**"No valid response received"**
- The AI provider might be experiencing issues
- Try switching to a different provider
- Check your internet connection

**Plugin not appearing**
- Make sure the plugin is in the correct directory: `addons/ai_coding_assistant/`
- Enable the plugin in Project Settings > Plugins
- Restart Godot if necessary

### Performance Tips
- Use lower temperature (0.3-0.5) for more focused code generation
- Reduce max tokens if responses are too long
- Disable auto-suggestions if they're too frequent

## API Limits & Costs

### Free Tier Limits
- **Gemini**: 60 requests per minute, 1500 requests per day
- **Hugging Face**: Rate limited, but generous for personal use
- **Cohere**: 100 requests per month (free tier)

### Staying Within Limits
- Use the chat efficiently - combine multiple questions
- Cache responses when possible
- Consider upgrading to paid tiers for heavy usage

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Areas for Contribution
- Additional AI provider integrations
- Better code analysis algorithms
- UI/UX improvements
- Documentation and examples
- Bug fixes and optimizations

## License

This plugin is released under the MIT License. See LICENSE file for details.

## Testing

The plugin includes a comprehensive test suite to verify functionality:

### Test Directory
All test scripts are located in the `test/` directory:
- **Core Tests**: `test_plugin.gd`, `verify_plugin.gd`, `final_test.gd`
- **API Tests**: `test_gemini_api.gd`, `test_gemini_2_flash.gd`, `simple_api_test.gd`
- **UI Tests**: `test_resizable_dock.gd`, `test_enhanced_features.gd`, `test_flexible_boxes.gd`
- **Debug Tests**: `debug_api_manager.gd`, `check_version.gd`

### Running Tests
1. Open Godot with the project
2. Go to **Tools > Execute Script**
3. Select a test file from the `test/` directory
4. Click **Execute** and check the output

### Quick Test
Run `test/test_plugin.gd` for a quick verification that everything is working.

## Support

- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Join our community discussions
- **Documentation**: Check the wiki for detailed guides

## Changelog

### Version 1.3.0 (Latest)
- **📦 Flexible Boxes**: Enhanced chat and code boxes for optimal reading/writing
- **📝 Enhanced Markdown**: Rich text formatting with code blocks, headers, bold, italic
- **🔄 View Toggles**: Word wrap (↩/→) and line numbers (#/∅) controls
- **⏰ Timestamps**: Chat messages now show time for better tracking
- **📏 Larger Minimum Sizes**: 150px chat, 120px code for better readability
- **🎨 Better Styling**: Improved fonts, spacing, and visual formatting

### Version 1.2.0
- **📋 Enhanced Selection & Copy**: Right-click context menus for chat and code
- **🎯 Quick Action Buttons**: Clear (🗑), Copy (📋), Save (💾) buttons
- **⌨️ Keyboard Shortcuts**: Ctrl+C, Ctrl+S, Ctrl+L, F1, Escape support
- **💾 File Export**: Save chat history and code to files with dialogs
- **✏️ Editable Code**: Generated code can now be edited directly
- **🖱️ Text Selection**: Full selection support in chat and code areas

### Version 1.1.0
- **🎨 Resizable UI Interface**: Complete dock redesign with resizable sections
- **📏 Flexible Layout**: Drag splitters to adjust chat/code section sizes
- **🔽 Collapsible Sections**: Hide/show API settings and quick actions
- **💾 Persistent Layout**: Layout preferences saved between sessions
- **📱 Responsive Design**: Better adaptation to different screen sizes
- **✨ Improved UX**: Better spacing, buttons, and visual hierarchy

### Version 1.0.0
- Initial release
- Basic chat functionality
- Code generation with diff viewer
- Support for Gemini, Hugging Face, and Cohere APIs
- Real-time code analysis
- Quick action templates

---

**Happy Coding with AI! 🚀**
