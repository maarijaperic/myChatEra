#!/usr/bin/env python3
"""
Script to fix screenshot background issue by moving RepaintBoundary to wrap the entire Stack
"""
import re
import os

# List of screen files to update
screen_files = [
    'lib/screen_type_ab_personality.dart',
    'lib/screen_red_green_flags.dart',
    'lib/screen_guess_zodiac.dart',
    'lib/screen_introvert_extrovert.dart',
    'lib/screen_advice_most_asked.dart',
    'lib/screen_love_language.dart',
    'lib/screen_past_life_persona.dart',
    'lib/screen_movie_title.dart',
    'lib/screen_chat_era.dart',
    'lib/screen_chat_days_tracker.dart',
    'lib/screen_gpt_oclock.dart',
    'lib/screen_most_used_word.dart',
    'lib/screen_chat_streak.dart',
    'lib/screen_curiosity_index.dart',
]

def fix_screenshot_background(file_path):
    """Fix screenshot background by moving RepaintBoundary to wrap Stack"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Pattern 1: Scaffold with body: Stack, then SafeArea with RepaintBoundary inside
        # We want to move RepaintBoundary to wrap the Stack
        
        # Find the pattern: return Scaffold( body: Stack( ... SafeArea( child: RepaintBoundary(
        pattern1 = r'(return Scaffold\(\s+body:\s+)Stack\(([^)]*fit:\s*StackFit\.expand,)?\s*children:\s*\[(.*?)// Main content\s+SafeArea\(\s+child:\s+)RepaintBoundary\(\s+key:\s+_screenshotKey,'
        
        replacement1 = r'\1RepaintBoundary(\n        key: _screenshotKey,\n        child: Stack(\2\n          children: [\3SafeArea(\n              child:'
        
        content = re.sub(pattern1, replacement1, content, flags=re.DOTALL)
        
        # Pattern 2: Fix closing brackets - remove extra closing for RepaintBoundary before Stack closes
        # Find: ]\n      ),\n    ),\n  ],\n), and replace with ]\n      ),\n    ),\n  ],\n    ),\n  ),\n);
        # This is tricky, so we'll do a simpler approach
        
        # Pattern 3: Fix the SingleChildScrollView duplication if it exists
        content = re.sub(
            r'(child:\s+SingleChildScrollView\(\s+)child:\s+SingleChildScrollView\(',
            r'\1',
            content
        )
        
        # Pattern 4: Fix Padding indentation
        content = re.sub(
            r'(child:\s+Padding\(\s+)padding:\s+EdgeInsets\.symmetric\(',
            r'\1padding: EdgeInsets.symmetric(',
            content
        )
        
        # Pattern 5: Fix closing - ensure proper structure
        # Before: ]\n                ),\n              ),\n            ),\n          ),\n        ],\n      ),\n    );
        # After:  ]\n                ),\n              ),\n            ),\n          ],\n        ),\n      ),\n    );
        content = re.sub(
            r'(\]\s*),\s*\),\s*\),\s*\),\s*\],\s*\),\s*\);',
            r'\1],\n        ),\n      ),\n    );',
            content
        )
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✓ Fixed {file_path}")
            return True
        else:
            print(f"  No changes needed for {file_path}")
            return False
            
    except Exception as e:
        print(f"✗ Error processing {file_path}: {e}")
        return False

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))
    fixed_count = 0
    
    for screen_file in screen_files:
        file_path = os.path.join(base_dir, screen_file)
        if os.path.exists(file_path):
            if fix_screenshot_background(file_path):
                fixed_count += 1
        else:
            print(f"  File not found: {file_path}")
    
    print(f"\n✓ Fixed {fixed_count} files")











