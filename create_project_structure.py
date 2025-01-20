import os

def create_project_structure(institution, project_name):
    # Define the base path for your research folder
    base_path = r"C:\Users\hanna\OneDrive\Desktop\Research"

    # Combine institution and project name to form the full path
    project_path = os.path.join(base_path, institution, project_name)

    # Define the folder structure
    folders = [
        f"{project_path}/data/raw",
        f"{project_path}/data/processed",
        f"{project_path}/scripts",
        f"{project_path}/results/figures",
        f"{project_path}/results/tables",
        f"{project_path}/results/supplementary",
        f"{project_path}/manuscript/versions/v1_initial",
        f"{project_path}/manuscript/versions/v2_revisions",
        f"{project_path}/manuscript/versions/final",
        f"{project_path}/manuscript/cover_letter",
        f"{project_path}/manuscript/reviews",
        f"{project_path}/manuscript/journal_decisions",
        f"{project_path}/docs",
        f"{project_path}/presentation_materials"
    ]

    # Create the folders
    for folder in folders:
        os.makedirs(folder, exist_ok=True)

    print(f"Project structure created for: {institution}/{project_name}")

# Example usage
create_project_structure("UNC", "OystercatcherHabitat_Geomorphology")
