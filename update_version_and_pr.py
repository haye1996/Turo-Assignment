import sys
import os
import re
import subprocess
from datetime import datetime

TERRAFORM_VARS_FILE = 'terraform/variables.tf'


def update_image_version(image_var, new_tag):
    with open(TERRAFORM_VARS_FILE, 'r') as f:
        lines = f.readlines()

    pattern = re.compile(rf'variable "{image_var}".*?default\s*=\s*"[^"]*"', re.DOTALL)
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
    subprocess.run(['git', 'checkout', '-b', branch_name], check=True)
    subprocess.run(['git', 'add', TERRAFORM_VARS_FILE], check=True)
    subprocess.run(['git', 'commit', '-m', pr_title], check=True)
    subprocess.run(['git', 'push', '-u', 'origin', branch_name], check=True)
    subprocess.run(['gh', 'pr', 'create', '--title', pr_title, '--body', pr_body, '--merge-method', 'squash'], check=True)

def main():
    if len(sys.argv) != 2:
        print('Usage: python update_version_and_pr.py <new_version_tag>')
        sys.exit(1)
    new_tag = sys.argv[1]
    image_var = 'image1'  # Change to 'image2' or loop for both if needed
    update_image_version(image_var, new_tag)
    branch_name = f'update-image1-{new_tag}-{datetime.now().strftime("%Y%m%d%H%M%S")}'
    pr_title = f'Update {image_var} to {new_tag}'
    pr_body = f'Automated PR to update {image_var} to {new_tag} for deployment.'
    git_commit_push_pr(branch_name, pr_title, pr_body)
    print(f'PR created for {image_var} with tag {new_tag}')


if __name__ == '__main__':
    main() 