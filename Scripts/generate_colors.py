import os
import json

colors = {
    "Primary": "#281C9D",
    "Primary80": "#5655B9",
    "Primary40": "#A8A3D7",
    "Primary10": "#F2F1F9",
    "Neutral100": "#343434",
    "Neutral70": "#898989",
    "Neutral60": "#989898",
    "Neutral40": "#CACACA",
    "Neutral20": "#E0E0E0",
    "White": "#FFFFFF",
    "SemanticError": "#FF4267",
    "SemanticInfo": "#0890FE",
    "SemanticWarning": "#FFAF2A",
    "SemanticSuccess": "#52D5BA",
    "SemanticOrange": "#FB6B18"
}

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))

base_path = "/Users/tomthecat/AppFoundation/Sources/AppFoundationResources/Resources/Assets.xcassets/Colors"
os.makedirs(base_path, exist_ok=True)

# Create Contents.json for the Colors folder
folder_contents = {
    "info": {
        "version": 1,
        "author": "xcode"
    }
}
with open(os.path.join(base_path, "Contents.json"), "w") as f:
    json.dump(folder_contents, f, indent=2)

for name, hex_code in colors.items():
    color_path = os.path.join(base_path, f"{name}.colorset")
    os.makedirs(color_path, exist_ok=True)
    
    r, g, b = hex_to_rgb(hex_code)
    
    contents = {
        "colors": [
            {
                "idiom": "universal",
                "color": {
                    "color-space": "srgb",
                    "components": {
                        "red": f"{r/255.0:.3f}",
                        "alpha": "1.000",
                        "blue": f"{b/255.0:.3f}",
                        "green": f"{g/255.0:.3f}"
                    }
                }
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    with open(os.path.join(color_path, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

print(f"Generated {len(colors)} color sets in {base_path}")
