import sys
import os
import re
import subprocess
from datetime import datetime

TERRAFORM_VARS_FILE = 'terraform/variables.tf'


def get_current_image_version(image_var):
    """Get the current image version from terraform/variables.tf"""
    with open(TERRAFORM_VARS_FILE, 'r') as f:
        content = f.read()
    
    pattern = rf'variable "{image_var}".*?default\s*=\s*"haitongyedocker/devops-interview-app:([^"]*)"'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        return match.group(1)
    return None


def update_image_version(image_var, new_tag):
    """Update the image version in terraform/variables.tf"""
    with open(TERRAFORM_VARS_FILE, 'r') as f:
        lines = f.readlines()

    new_lines = []
    in_var = False
    for line in lines:
        if line.strip().startswith(f'variable "{image_var}"'):
            in_var = True
            new_lines.append(line)
            continue
        if in_var and 'default' in line:
            new_line = re.sub(r'default\s*=\s*"[^"]*"', f'default     = "haitongyedocker/devops-interview-app:{new_tag}"', line)
            new_lines.append(new_line)
            in_var = False
        else:
            new_lines.append(line)
    
    with open(TERRAFORM_VARS_FILE, 'w') as f:
        f.writelines(new_lines)


def git_commit_push_pr(branch_name, pr_title, pr_body):
    """Create git branch, commit, push, and create PR"""
    subprocess.run(['git', 'checkout', '-b', branch_name], check=True)
    subprocess.run(['git', 'add', TERRAFORM_VARS_FILE], check=True)
    subprocess.run(['git', 'commit', '-m', pr_title], check=True)
    subprocess.run(['git', 'push', '-u', 'origin', branch_name], check=True)
    subprocess.run(['gh', 'pr', 'create', '--title', pr_title, '--body', pr_body], check=True)


def main():
    if len(sys.argv) != 2:
        print('Usage: python3 update_version_and_pr.py <version_tag>')
        print('Examples:')
        print('  python3 update_version_and_pr.py latest')
        print('  python3 update_version_and_pr.py 20250713-220636')
        sys.exit(1)
    
    new_tag = sys.argv[1]
    image_var = 'image1'  # Change to 'image2' or loop for both if needed
    
    # Get current version
    current_version = get_current_image_version(image_var)
    if current_version is None:
        print(f"Error: Could not find current version for {image_var}")
        sys.exit(1)
    
    print(f"Current {image_var} version: {current_version}")
    print(f"Requested version: {new_tag}")
    
    # Check if update is needed
    if current_version == new_tag:
        print(f"No change needed. {image_var} is already at version {new_tag}")
        return
    
    # Update the version
    update_image_version(image_var, new_tag)
    
    # Create PR
    branch_name = f'update-image1-{new_tag}-{datetime.now().strftime("%Y%m%d%H%M%S")}'
    pr_title = f'Update {image_var} to {new_tag}'
    pr_body = f'Automated PR to update {image_var} to {new_tag} for deployment.'
    
    try:
        git_commit_push_pr(branch_name, pr_title, pr_body)
        print(f'PR created for {image_var} with tag {new_tag}')
    except subprocess.CalledProcessError as e:
        print(f"Error creating PR: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main() 