# Godot Version Compatibility Guide

## 🎯 **Target Version: Godot 4.x**

This plugin is primarily designed for **Godot 4.x** (4.0+) but includes compatibility notes for Godot 3.x users.

## 🔍 **Check Your Godot Version**

1. **Open Godot**
2. **Help > About** or check the title bar
3. **Version format**: `4.x.x` = Godot 4, `3.x.x` = Godot 3

## 📋 **Version-Specific Information**

### **Godot 4.x (Recommended)**
- ✅ **Full compatibility** - All features work
- ✅ **Modern syntax** - Uses `@tool`, `func():` lambdas, modern signals
- ✅ **Latest APIs** - HTTPRequest, EditorInterface, etc.
- ✅ **Performance optimized**

**Project Settings:**
- `config_version=5` (Godot 4.x)
- Uses `PackedStringArray` for plugin config

### **Godot 3.x (Limited Support)**
- ⚠️ **Partial compatibility** - Core features work with modifications
- ⚠️ **Syntax differences** - Requires `tool` instead of `@tool`
- ⚠️ **Signal syntax** - Uses `connect(self, "method")` format
- ⚠️ **No lambda functions** - Requires separate callback methods

**Project Settings:**
- `config_version=4` (Godot 3.x)
- Uses `PoolStringArray` for plugin config

## 🔧 **If You're Using Godot 3.x**

### **Quick Fix for Godot 3.x:**

1. **Replace `@tool` with `tool`** in all `.gd` files:
   ```bash
   # In terminal (Linux/Mac):
   find addons/ai_coding_assistant -name "*.gd" -exec sed -i 's/@tool/tool/g' {} \;
   
   # Or manually edit each file:
   # Change: @tool
   # To: tool
   ```

2. **Update signal connections** (if needed):
   ```gdscript
   # Godot 4.x (current):
   button.pressed.connect(_on_button_pressed)
   
   # Godot 3.x (if errors occur):
   button.connect("pressed", self, "_on_button_pressed")
   ```

3. **Update project.godot**:
   ```ini
   # Change this line:
   enabled=PackedStringArray("res://addons/ai_coding_assistant/plugin.cfg")
   
   # To this for Godot 3.x:
   enabled=PoolStringArray("res://addons/ai_coding_assistant/plugin.cfg")
   ```

## 🚨 **Common Version-Related Errors**

### **Parse Error: Unexpected '@'**
- **Cause**: Using `@tool` in Godot 3.x
- **Fix**: Change `@tool` to `tool`

### **Invalid call: Nonexistent function 'connect'**
- **Cause**: Different signal syntax between versions
- **Fix**: Use `signal.connect(self, "method_name")` for Godot 3.x

### **Unknown type: 'PackedStringArray'**
- **Cause**: Godot 3.x uses different array types
- **Fix**: Change to `PoolStringArray` in project.godot

## 🎯 **Recommended Approach**

### **For New Projects:**
- ✅ **Use Godot 4.x** - Latest features, better performance, active development
- ✅ **Plugin works out-of-the-box**

### **For Existing Godot 3.x Projects:**
- ⚠️ **Consider upgrading** to Godot 4.x for best experience
- ⚠️ **Or apply the fixes** mentioned above for Godot 3.x compatibility

## 🔍 **Version Detection Script**

Run this script to check compatibility:

```gdscript
# Tools > Execute Script
tool
extends EditorScript

func _run():
    var version = Engine.get_version_info()
    print("Godot Version: ", version.major, ".", version.minor, ".", version.patch)
    
    if version.major >= 4:
        print("✅ Godot 4.x detected - Full plugin compatibility!")
    elif version.major == 3:
        print("⚠️ Godot 3.x detected - May need syntax adjustments")
        print("See VERSION_COMPATIBILITY.md for fixes")
    else:
        print("❌ Unsupported Godot version")
```

## 📚 **API Differences**

### **Godot 4.x Features Used:**
- `@tool` annotation
- Modern signal syntax: `signal.connect(callable)`
- `PackedStringArray`
- `EditorInterface.get_script_editor()`
- Lambda functions: `func(): code`

### **Godot 3.x Equivalents:**
- `tool` keyword
- Old signal syntax: `signal.connect(object, "method")`
- `PoolStringArray`
- `EditorInterface.get_script_editor()`
- Separate callback methods

## 🎉 **Summary**

- **Godot 4.x**: ✅ **Works perfectly** - No changes needed
- **Godot 3.x**: ⚠️ **Needs minor adjustments** - Follow the fixes above

The plugin is designed to provide the best experience on Godot 4.x while maintaining basic compatibility with Godot 3.x through simple syntax adjustments.

**Recommendation**: Use Godot 4.x for the full AI coding assistant experience! 🚀
