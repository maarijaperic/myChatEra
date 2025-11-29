#!/usr/bin/env python3
"""
Script to update all screens to use Instagram sharing functionality.
This script adds ScreenshotController and updates share buttons.
"""

import re
import os

# List of screen files to update
SCREENS = [
    'screen_chat_streak.dart',
    'screen_love_language.dart',
    'screen_past_life_persona.dart',
    'screen_advice_most_asked.dart',
    'screen_introvert_extrovert.dart',
    'screen_guess_zodiac.dart',
    'screen_type_ab_personality.dart',
    'screen_red_green_flags.dart',
    'screen_gpt_oclock.dart',
    'screen_most_used_word.dart',
    'screen_chat_days_tracker.dart',
    'screen_chat_era.dart',
    'screen_mbti_personality.dart',
    'screen_movie_title.dart',
]

# Gradient colors for each screen (if different from default)
GRADIENTS = {
    'screen_chat_streak.dart': '[Color(0xFFFF8E53), Color(0xFFFFB366)]',
    'screen_most_used_word.dart': '[Color(0xFF8B6F47), Color(0xFFA0826D)]',
    'screen_chat_days_tracker.dart': '[Color(0xFF4ECDC4), Color(0xFF6FE3AA)]',
    'screen_gpt_oclock.dart': '[Color(0xFFFF8C42), Color(0xFFFFB366)]',
    'screen_advice_most_asked.dart': '[Color(0xFF10B981), Color(0xFF34D399)]',
}

def update_screen(file_path):
    """Update a single screen file."""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return False
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 1. Add imports if not present
    if 'package:screenshot/screenshot.dart' not in content:
        # Find the last import line
        import_pattern = r"(import\s+['\"].*?['\"];)"
        imports = re.findall(import_pattern, content)
        if imports:
            last_import = imports[-1]
            new_imports = "import 'package:screenshot/screenshot.dart';\nimport 'package:gpt_wrapped2/widgets/instagram_share_button.dart';"
            content = content.replace(last_import, last_import + '\n' + new_imports)
    
    # 2. Add ScreenshotController to State class
    if 'ScreenshotController _screenshotController' not in content:
        # Find the State class and add controller
        state_pattern = r"(class\s+\w+State.*?\{[^}]*?)(late\s+AnimationController\s+\w+Controller;)"
        match = re.search(state_pattern, content, re.DOTALL)
        if match:
            before = match.group(1)
            anim_controller = match.group(2)
            content = content.replace(
                match.group(0),
                before + anim_controller + '\n  final ScreenshotController _screenshotController = ScreenshotController();'
            )
    
    # 3. Wrap SafeArea with Screenshot
    if 'Screenshot(' not in content or 'controller: _screenshotController' not in content:
        safearea_pattern = r"(SafeArea\s*\(\s*child:\s*)(SingleChildScrollView|Column|ListView)"
        match = re.search(safearea_pattern, content)
        if match:
            before = match.group(1)
            child = match.group(2)
            replacement = before + 'Screenshot(\n                controller: _screenshotController,\n                child: ' + child
            content = re.sub(safearea_pattern, replacement, content, count=1)
            
            # Close Screenshot widget - find the matching closing parenthesis
            # This is tricky, so we'll do it manually per file
    
    # 4. Replace _SmallShareToStoryButton with SmallShareToStoryButton
    gradient = GRADIENTS.get(os.path.basename(file_path), '[Color(0xFFFF8FB1), Color(0xFFFFB5D8)]')
    
    old_button_pattern = r"_SmallShareToStoryButton\s*\(\s*shareText:\s*([^,]+),?\s*\)"
    new_button = f"SmallShareToStoryButton(\n                        shareText: \\1,\n                        screenshotController: _screenshotController,\n                        accentGradient: const {gradient},\n                      )"
    content = re.sub(old_button_pattern, new_button, content)
    
    # 5. Remove old _SmallShareToStoryButton class definition
    old_class_pattern = r"// Small Share to Story Button\s*class _SmallShareToStoryButton.*?\n\}"
    content = re.sub(old_class_pattern, "", content, flags=re.DOTALL)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {file_path}")
        return True
    else:
        print(f"No changes needed: {file_path}")
        return False

if __name__ == '__main__':
    lib_dir = os.path.join(os.path.dirname(__file__), 'lib')
    updated = 0
    for screen in SCREENS:
        file_path = os.path.join(lib_dir, screen)
        if update_screen(file_path):
            updated += 1
    
    print(f"\nUpdated {updated} out of {len(SCREENS)} screens.")




