import subprocess
import os
import tempfile
import shutil

# Dictionary of Git URLs and directories
repos_and_dirs = {
    'git@github.com:prometheus-operator/prometheus-operator.git': 'example/prometheus-operator-crd',
    'git@github.com:kubernetes-sigs/gateway-api.git': 'config/crd/standard',
}

# Loop through the repositories and directories
for repo_url, repo_dir in repos_and_dirs.items():
    print(repo_dir)

    # Clone the Git repository to a temporary directory using SSH
    temp_dir = tempfile.mkdtemp()
    subprocess.run(['git', 'clone', repo_url, temp_dir])

    # Change to the specified directory within the repository
    os.chdir(os.path.join(temp_dir, repo_dir))

    # Loop through the YAML files in the directory and apply them
    for file in os.listdir('.'):
        if file.endswith('.yaml'):
            subprocess.run(['kubectl', 'apply', '-f', file])

    # Clean up the temporary directory
    shutil.rmtree(temp_dir)

# Retrieve the file from the experimental directory and apply it
experimental_file = 'git@github.com:kubernetes-sigs/gateway-api.git:config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml'
temp_file = tempfile.NamedTemporaryFile(delete=False)
subprocess.run(['git', 'archive', '--remote=' + experimental_file, 'HEAD', 'config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml'], stdout=temp_file)
temp_file_path = temp_file.name
temp_file.close()

subprocess.run(['kubectl', 'apply', '-f', temp_file_path])
os.remove(temp_file_path)

# Additional operations
operations = [
    ('cni/charts', '../../../../kubernetes/apps/kube-system/cilium/app/values.yaml', 'cni/values.yaml', 'cni'),
    ('kubelet-csr-approver/charts', '../../../../kubernetes/apps/kube-system/kubelet-csr-approver/app/values.yaml', 'kubelet-csr-approver/values.yaml', 'kubelet-csr-approver'),
]

for chart_path, values_path, output_values, chart_name in operations:
    shutil.rmtree(chart_path, ignore_errors=True)
    subprocess.run(['envsubst', f'<{values_path} >{output_values}'])
    subprocess.run(['kustomize', 'build', '--enable-helm', chart_path, '|', 'kubectl', 'apply', '-f', '-'])
    os.remove(output_values)
    shutil.rmtree(chart_path)
