# AI Coding Assistant - Installation & Quick Start Guide

## 🚀 Quick Installation

### Option 1: Clone/Download this Repository
```bash
git clone <repository-url>
cd ai-coding-assistant-godot
```

### Option 2: Manual Setup
1. Create a new Godot project
2. Create the folder structure: `addons/ai_coding_assistant/`
3. Copy all the plugin files to this folder

## 📁 Required File Structure
```
your_project/
├── addons/
│   └── ai_coding_assistant/
│       ├── plugin.cfg
│       ├── plugin.gd
│       ├── ai_assistant_dock.gd
│       ├── ai_api_manager.gd
│       ├── code_analyzer.gd
│       ├── diff_viewer.gd
│       ├── settings_dialog.gd
│       ├── setup_guide.gd
│       └── README.md
├── project.godot
└── example_script.gd (optional demo)
```

## ⚡ Quick Start (5 minutes)

### Step 1: Enable the Plugin
1. Open your project in Godot
2. Go to **Project Settings > Plugins**
3. Find "AI Coding Assistant" and enable it
4. You should see an "AI Assistant" dock appear on the left side

### Step 2: Get a Free API Key
**Recommended: Google Gemini (Free & Powerful)**
1. Visit: https://makersuite.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the key

**Alternative: Hugging Face (Free)**
1. Sign up at: https://huggingface.co/
2. Go to Settings > Access Tokens
3. Create a new token with "Read" permissions

### Step 3: Configure the Plugin
1. In the AI Assistant dock, find "API Settings"
2. Select "Gemini (Free)" from the Provider dropdown
3. Paste your API key in the "API Key" field
4. Settings are saved automatically!

### Step 4: Test It Out
Try these commands in the chat:
- `"Hello, can you help me with GDScript?"`
- `"Create a simple player movement script"`
- `"Generate a health system for my game"`

## 🎯 Usage Examples

### Basic Chat
```
You: How do I create a singleton in Godot?
AI: To create a singleton in Godot, you can use the AutoLoad feature...
```

### Code Generation
```
You: Create a inventory system with add, remove, and display functions
AI: [Generates complete GDScript code]
```

### Code Explanation
1. Select code in your script editor
2. Click the "Explain" button
3. Get detailed explanations of what the code does

### Code Improvement
1. Select code in your script editor  
2. Click the "Improve" button
3. Get optimization and best practice suggestions

## 🔧 Advanced Configuration

### Settings Dialog
Click the ⚙ button in the AI Assistant dock to access:
- **Temperature**: Controls creativity (0.0 = deterministic, 1.0 = creative)
- **Max Tokens**: Maximum response length
- **Auto-suggestions**: Real-time code completion
- **Save History**: Persist chat between sessions

### API Provider Comparison

| Provider | Free Tier | Best For | Setup Difficulty |
|----------|-----------|----------|------------------|
| **Gemini** | 60 req/min, 1500/day | General coding, explanations | Easy |
| **Hugging Face** | Rate limited | Code completion | Easy |
| **Cohere** | 100 req/month | Code analysis | Medium |

## 🐛 Troubleshooting

### Plugin Not Appearing
- ✅ Check that all files are in `addons/ai_coding_assistant/`
- ✅ Enable the plugin in Project Settings > Plugins
- ✅ Restart Godot

### "API key not set" Error
- ✅ Make sure you entered the API key correctly
- ✅ Check that you selected the right provider
- ✅ Verify the API key is valid (test on the provider's website)

### "HTTP Error: 401/403"
- ✅ API key is invalid or expired
- ✅ You may have exceeded free tier limits
- ✅ Try a different provider

### No Response from AI
- ✅ Check your internet connection
- ✅ Try a simpler question first
- ✅ Switch to a different AI provider
- ✅ Check the provider's status page

### Performance Issues
- ✅ Lower the temperature setting (0.3-0.5)
- ✅ Reduce max tokens if responses are too long
- ✅ Disable auto-suggestions if they're too frequent

## 📊 API Usage Tips

### Staying Within Free Limits
- **Gemini**: 60 requests/minute, 1500/day
- **Hugging Face**: Generous but rate-limited
- **Cohere**: 100 requests/month

### Best Practices
- Combine multiple questions in one request
- Be specific to get better answers
- Use the diff viewer to review generated code
- Save frequently used code snippets

## 🔒 Privacy & Security

### API Key Security
- API keys are stored locally in `user://ai_assistant_settings.cfg`
- Keys are not shared or transmitted except to the chosen AI provider
- You can delete the settings file to remove stored keys

### Data Privacy
- Your code and questions are sent to the AI provider for processing
- Different providers have different privacy policies
- Consider using local AI models for sensitive code (future feature)

## 🆘 Getting Help

### Built-in Help
- Click the **?** button in the AI Assistant dock
- Follow the interactive setup guide
- Check the README.md for detailed documentation

### Community Support
- Report bugs on GitHub Issues
- Join community discussions
- Check the wiki for advanced guides

### Self-Help
- Run `test_plugin.gd` to verify installation
- Check Godot's console for error messages
- Try different AI providers if one isn't working

## 🎉 You're Ready!

Once you see the AI Assistant dock and can chat with the AI, you're all set! 

**Pro tip**: Start with simple questions and gradually explore more advanced features like code generation and the diff viewer.

Happy coding with AI! 🚀
