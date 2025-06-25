# 📦 Flexible Boxes Guide - AI Coding Assistant

## ✨ Enhanced Chat & Code Boxes

The AI Coding Assistant now features highly flexible and customizable chat and code boxes designed for optimal reading, writing, and code selection experience!

## 🎯 Key Enhancements

### 1. **Flexible Chat Box**
- **Enhanced Markdown Support**: Rich text formatting with code blocks, headers, bold, italic
- **Word Wrap Toggle**: Switch between wrapped and unwrapped text (↩/→ button)
- **Better Text Selection**: Full selection support with context menus
- **Timestamps**: Each message shows time for better tracking
- **Larger Minimum Size**: 150px minimum height for better readability

### 2. **Enhanced Code Box**
- **Line Numbers Toggle**: Show/hide line numbers (# button)
- **Full Editing Support**: Complete text editing with multiple cursors
- **No Word Wrap**: Code maintains proper formatting
- **Horizontal Scrolling**: View long lines without wrapping
- **Larger Minimum Size**: 120px minimum height for better code viewing
- **Monospace Font**: Proper code formatting with consistent spacing

### 3. **View Options**
- **Persistent Preferences**: All view settings are saved between sessions
- **Quick Toggles**: One-click buttons for common view options
- **Visual Indicators**: Button states show current settings
- **Tooltips**: Helpful hints for all view controls

## 🎨 UI Layout

### Enhanced Chat Header
```
┌─ AI Chat ────────────── ↩ 🗑 ┐
│ [10:30] You: How do I...      │
│ [10:31] AI: Here's how to...  │
│ **Bold text** and `code`      │
│ ```                           │
│ code blocks with syntax       │
│ ```                           │
└───────────────────────────────┘
```

### Enhanced Code Header
```
┌─ Generated Code ──── # 📋 💾 ┐
│  1  extends CharacterBody2D   │
│  2                            │
│  3  func _ready():            │
│  4      print("Hello")        │
│                               │
└───────────────────────────────┘
```

## 🔧 View Controls

### Chat Box Controls
- **↩ Button**: Word wrap ON - text wraps to fit width
- **→ Button**: Word wrap OFF - text extends horizontally
- **🗑 Button**: Clear all chat history
- **Right-click**: Context menu with copy/save options

### Code Box Controls
- **# Button**: Line numbers ON - shows line numbers
- **∅ Button**: Line numbers OFF - hides line numbers
- **📋 Button**: Copy code to clipboard
- **💾 Button**: Save code to file
- **Right-click**: Full editing context menu

## 📝 Markdown Support

### Supported Formatting
- **Headers**: `# Header 1`, `## Header 2`, `### Header 3`
- **Bold Text**: `**bold text**` → **bold text**
- **Italic Text**: `*italic text*` → *italic text*
- **Inline Code**: `` `code` `` → `code` (with background)
- **Code Blocks**: 
  ```
  ```
  multi-line code
  with syntax highlighting
  ```
  ```

### Enhanced Chat Display
- **Timestamps**: Each message shows [HH:MM] format
- **Color Coding**: Different colors for You, AI, System, Error messages
- **Rich Formatting**: BBCode support for enhanced text display
- **Code Highlighting**: Special formatting for code snippets

## 🎯 Flexible Sizing

### Responsive Design
- **Minimum Sizes**: Chat (150px), Code (120px) for readability
- **Expandable**: Both boxes grow with available space
- **Splitter Control**: Drag divider to adjust chat/code ratio
- **Dock Resizing**: Entire dock can be resized by dragging edges

### Size Optimization
- **Small Screens**: Collapse sections, focus on one area
- **Large Screens**: Expand both areas, use full space
- **Custom Ratios**: Set preferred chat/code size ratio
- **Memory**: Layout preferences saved automatically

## 💡 Best Practices

### For Reading
1. **Enable Word Wrap** (↩) for long chat messages
2. **Expand Chat Area** by dragging splitter down
3. **Use Markdown** formatting for better readability
4. **Scroll Through History** to review past conversations

### For Writing Code
1. **Enable Line Numbers** (#) for code reference
2. **Disable Word Wrap** to maintain code structure
3. **Expand Code Area** by dragging splitter up
4. **Edit Directly** in the code box before applying

### For Code Selection
1. **Use Line Numbers** for precise selection
2. **Double-click** to select words
3. **Triple-click** to select entire lines
4. **Drag to Select** custom ranges
5. **Ctrl+A** to select all code

## 🚀 Advanced Features

### Enhanced Text Editing
- **Multiple Cursors**: Hold Ctrl and click for multiple edit points
- **Drag & Drop**: Move selected text by dragging
- **Smart Selection**: Word and line selection with double/triple click
- **Undo/Redo**: Full editing history support

### Context Menus
- **Chat Context**: Copy selected, copy all, save history, clear
- **Code Context**: Cut, copy, paste, select all, save file, clear
- **Built-in Menus**: Native Godot context menus for standard operations

### Keyboard Shortcuts
- **Ctrl+C**: Copy (context-aware)
- **Ctrl+V**: Paste (in code area)
- **Ctrl+A**: Select all
- **Ctrl+Z**: Undo
- **Ctrl+Y**: Redo
- **Ctrl+L**: Clear chat

## 🎉 Benefits

### Enhanced Productivity
- **Faster Reading**: Better formatting and larger text areas
- **Easier Editing**: Full-featured code editing capabilities
- **Quick Actions**: One-click toggles for common operations
- **Persistent Settings**: No need to reconfigure each time

### Better User Experience
- **Professional Feel**: Modern interface with proper text handling
- **Flexible Layout**: Adapts to your workflow needs
- **Visual Feedback**: Clear indicators for all settings
- **Intuitive Controls**: Easy-to-understand button symbols

### Improved Code Handling
- **Better Visibility**: Line numbers and proper formatting
- **Easy Selection**: Multiple ways to select text
- **Direct Editing**: Modify generated code before applying
- **Export Options**: Save code and conversations easily

## 🔄 Getting Started

1. **Try the Toggle Buttons**: Click ↩/→ and #/∅ to see the difference
2. **Resize the Boxes**: Drag the splitter to find your preferred ratio
3. **Test Markdown**: Send messages with **bold**, *italic*, and `code`
4. **Edit Some Code**: Generate code and try editing it directly
5. **Use Context Menus**: Right-click to explore all options

The flexible boxes make the AI Coding Assistant perfect for both reading conversations and working with code! 📦✨
