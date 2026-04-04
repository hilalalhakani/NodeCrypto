import os
import re

# Configuration
SNAPSHOTS_DIR = "Packages/Tests/SnapshotsTests/__Snapshots__"
README_PATH = "README.md"
MARKER_START = "<!-- SNAPSHOT_GALLERY_START -->"
MARKER_END = "<!-- SNAPSHOT_GALLERY_END -->"

# Mapping folder names to readable section headers
SECTION_MAPPING = {
    "EditProfileTests": "👤 Profile Features",
    "ProfileSnapshotsTests": "👤 Profile Features",
    "HomeTests": "🏠 Home Features",
    "SearchFeatureTests": "🔍 Search Features",
    "ConnectWalletSnapshotsTests": "👛 Wallet Connection",
    "OnboardingSnapshotsTests": "🎯 Onboarding",
    "NotificationsSnapshotsTests": "🔔 Notifications",
    "CreateFeatureSnapshotsTests": "🎨 NFT Creation",
    "PlayerViewSnapshotsTests": "🎬 Player View",
}

def clean_title(filename):
    # Remove extension
    name = os.path.splitext(filename)[0]
    # Remove common snapshot suffixes/prefixes
    name = re.sub(r"^test_", "", name)
    name = re.sub(r"^test", "", name)
    name = re.sub(r"\.test.*$", "", name)
    name = re.sub(r"-light$", "", name)
    name = re.sub(r"-dark$", "", name)
    
    # Split camelCase and underscores
    name = re.sub(r"([a-z])([A-Z])", r"\1 \2", name)
    name = name.replace("_", " ")
    
    # Capitalize
    return name.title().strip()

def get_snapshots():
    features = {}
    if not os.path.exists(SNAPSHOTS_DIR):
        print(f"Directory {SNAPSHOTS_DIR} not found.")
        return features

    for folder in sorted(os.listdir(SNAPSHOTS_DIR)):
        folder_path = os.path.join(SNAPSHOTS_DIR, folder)
        if not os.path.isdir(folder_path):
            continue
        
        section_name = SECTION_MAPPING.get(folder, folder.replace("SnapshotsTests", "").replace("Tests", "") + " Features")
        
        images = []
        for file in sorted(os.listdir(folder_path)):
            if file.endswith(".png"):
                # Avoid duplicates (e.g. if we have both test.png and test-light.png)
                # For now, we just take all, but we could filter.
                images.append({
                    "title": clean_title(file),
                    "path": f"./{SNAPSHOTS_DIR}/{folder}/{file}"
                })
        
        if images:
            if section_name not in features:
                features[section_name] = []
            features[section_name].extend(images)
            
    return features

def generate_markdown(features):
    lines = ["\n"]
    for section, images in features.items():
        lines.append(f"### {section}\n\n")
        
        # Split images into rows of max 5
        for i in range(0, len(images), 5):
            row = images[i:i+5]
            # Header Row
            lines.append("| " + " | ".join([f"**{img['title']}**" for img in row]) + " |\n")
            # Separator Row
            lines.append("| " + " | ".join(["---"] * len(row)) + " |\n")
            # Image Row
            lines.append("| " + " | ".join([f'<img src="{img["path"]}" width="180"/>' for img in row]) + " |\n")
            lines.append("\n")
            
    return "".join(lines)

def update_readme():
    if not os.path.exists(README_PATH):
        print(f"{README_PATH} not found.")
        return

    features = get_snapshots()
    new_content = generate_markdown(features)
    
    with open(README_PATH, "r") as f:
        content = f.read()
    
    pattern = re.compile(f"{re.escape(MARKER_START)}.*?{re.escape(MARKER_END)}", re.DOTALL)
    
    if MARKER_START in content and MARKER_END in content:
        updated_content = pattern.sub(f"{MARKER_START}{new_content}{MARKER_END}", content)
        with open(README_PATH, "w") as f:
            f.write(updated_content)
        print("Successfully updated README.md with snapshots.")
    else:
        print(f"Markers {MARKER_START} or {MARKER_END} not found in {README_PATH}.")

if __name__ == "__main__":
    update_readme()
