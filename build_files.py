"""
Generated base/Dockerfile and os/build.sh from files templates
"""
import os

import config


BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def save_build_sh(build_sh_conf):
    git_clone_lines = []
    for conf in build_sh_conf:
        url = 'git clone {}'.format(config.REPOSITORIES_TYPES[conf['type']])
        git_clone_lines.append(url % conf)

    with open(os.path.join(BASE_DIR, 'build.sh.tmpl'), 'r') as file_obj:
        content = file_obj.read()
        content = content.format(
            git_clone="\n".join(git_clone_lines),
            make_list=" ".join([i['repo_name'] for i in build_sh_conf])
        )
        with open(os.path.join(BASE_DIR, 'os/build.sh'), 'w+') as f:
            f.write(content)


def main():
    build_sh_conf = []
    for repo in config.REPOSITORIES:
        fork = "{}_FORK".format(repo['repo_name'].upper())
        branch = "{}_BRANCH".format(repo['repo_name'].upper())
        fork = os.environ.get(fork, repo['owner'])
        branch = os.environ.get(branch, repo['default_branch'])
        build_sh_conf.append({
            'fork': fork,
            'branch': branch,
            'owner': repo['owner'],
            'repo_name': repo['repo_name'],
            'type': repo['type']
        })

    save_build_sh(build_sh_conf)


if __name__ == '__main__':
    main()
