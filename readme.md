<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD033 -->

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
<img src="https://raw.githubusercontent.com/snoopy82481/home_cluster/main/docs/src/images/logo.png" align="center" alt="home_cluster" width="144" height="144" />

### My home Kubernetes cluster

_... managed with Flux, Renovate, and GitHub Actions_ <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f916/512.gif" alt="🤖" width="16" height="16" />

</div>

<!-- PROJECT SHIELDS-->
<div align="center">

[![GitHub License][license-shield]][license-url]&nbsp;&nbsp;
[![Talos][talos_shield]][talos_url]&nbsp;&nbsp;
[![kubernetes][kubernetes_shield]][kubernetes_url]&nbsp;&nbsp;
[![Flux][flux_shield]][flux_url]&nbsp;&nbsp;
![GitHub last commit](https://img.shields.io/github/last-commit/snoopy82481/home_cluster?style=for-the-badge)&nbsp;&nbsp;
[![Renovate][workflow_shield]][workflow_url]

</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_age_days&style=flat-square&label=Age)][kromgo_url]&nbsp;&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_uptime_days&style=flat-square&label=Uptime)][kromgo_url]&nbsp;&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_node_count&style=flat-square&label=Nodes)][kromgo_url]&nbsp;&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_pod_count&style=flat-square&label=Pods)][kromgo_url]&nbsp;&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_cpu_usage&style=flat-square&label=CPU)][kromgo_url]&nbsp;&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_memory_usage&style=flat-square&label=Memory)][kromgo_url]&nbsp;&nbsp;
[![Alerts](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fcluster_alert_count&style=flat-square&label=Alerts)][kromgo_url]

</div>

<div align="center">

[Report Bug](https://github.com/snoopy82481/home_cluster/issues/new?template=bug-report.yaml) · [Request Feature](https://github.com/snoopy82481/home_cluster/issues/new?template=feature-request.yaml)

</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <!-- <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li> -->
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <!-- <li><a href="#contact">Contact</a></li> -->
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

This repo is in major disarray at the moment. I am currently refactoring my existing repo [new_template_k3s][old_repo_url].

This is a complete rework of my existing cluster, that I tend to learn [Talos Linux][talos_url] with.

The cluster is managed by [Renovate][renovate_url] and [flux][flux_url] for automation of most of the process. Except the actual deployment configurations.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### :hammer_and_wrench: Built With

<div id="built_with">
  <a href="https://kubernetes.io">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kubernetes/kubernetes-plain.svg" alt="Kubernetes logo" width="40" height="40" />
  </a>&nbsp;
  <a href="https://fluxcd.io">
    <img src="docs/src/images/flux-horizontal-color.svg" alt="Flux logo" width="80" height="40" />
  </a>&nbsp;
  <a href="https://code.visualstudio.com">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vscode/vscode-original.svg" alt="VS-Code logo" width="40" height="40" />
  </a>&nbsp;
  <a href="https://talos.dev">
    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/talos/talos-original.svg" alt="Talos Logo" width="40" height="40" />
  </a>&nbsp;
  <a href="https://cilium.io">
    <img src="docs/src/images/cilium-logo-darkbg-horizontal-color.svg" alt="Cilium Logo" width="80" height="40" />
  </a>&nbsp;
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
<!-- ## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

* npm

  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo

   ```sh
   git clone https://github.com/snoopy82481/home_cluster.git
   ```

3. Install NPM packages

   ```sh
   npm install
   ```

4. Enter your API in `config.js`

   ```js
   const API_KEY = 'ENTER YOUR API';
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- USAGE EXAMPLES -->
<!-- ## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- ROADMAP -->

## Roadmap

- [x] Talos Config
- [x] Cilium CNI
- [x] Return cluster to operational state
- [x] Add Hajimari to the cluster [125](https://github.com/snoopy82481/home_cluster/issues/125)
- [x] Add monitoring [128](https://github.com/snoopy82481/home_cluster/issues/128)
  - [x] [Grafana](https://grafana.com)
  - [x] [Prometheus](https://grafana.com/oss/prometheus/)
- [x] Harden Kubernetes
  - [x] Add [Kyverno](https://kyverno.io) for Kubernetes Policy Management
- [ ] Documentation
  - [x] Create README.md
  - [ ] Document workflow (Github Pages/Cloudflare pages)

See the [open issues](https://github.com/snoopy82481/home_cluster/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
<!-- ## Contact

Your Name - email@email_client.com

Project Link: [https://github.com/snoopy82481/home_cluster](https://github.com/snoopy82481/home_cluster)

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

A lot of my insperation came from multiple users part of the k8s-at-home community.<br/>
There is a lot of code jacking from:

- [@onedr0p](https://github.com/onedr0p)
- [@bjw-s](https://github.com/bjw-s)
- [@Truxnell](https://github.com/Truxnell)
- [@xUnholy](https://github.com/xUnholy)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[license-shield]: https://img.shields.io/github/license/snoopy82481/home_cluster?style=for-the-badge
[license-url]: https://github.com/snoopy82481/home_cluster/blob/main/LICENSE
[workflow_shield]: https://img.shields.io/github/actions/workflow/status/snoopy82481/home_cluster/renovate.yaml?branch=main&style=for-the-badge&label=%20&color=blue
[workflow_url]: https://github.com/snoopy82481/home_cluster/actions/workflows/renovate.yaml
[pre-commit-shield]: https://img.shields.io/badge/pre--commit-enabled-blue?logo=pre-commit&logoColor=white&label&style=for-the-badge
[pre-comit-url]: https://github.com/pre-commit/pre-commit
[last-commit-shield]: https://img.shields.io/github/last-commit/snoopy82481/home_cluster/master?style=for-the-badge
[old_repo_url]: https://github.com/snoopy82481/new_template_k3s
[kubernetes_shield]: https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fkubernetes_version&style=for-the-badge&logo=talos&logoColor=white&color=blue
[kubernetes_url]: https://kubernetes.io
[renovatebot_shield]: https://img.shields.io/badge/Renovatebot-4A4A55?style=for-the-badge&logo=renovatebot&logoColor=white
[renovate_url]: https://www.mend.io/renovate/
[flux_shield]: https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Fflux_version&style=for-the-badge&logo=talos&logoColor=white&color=blue
[flux_url]: https://fluxcd.io
[talos_shield]: https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.idahobealefamily.com%2Ftalos_version&style=for-the-badge&logo=talos&logoColor=white&color=blue
[talos_url]: https://www.talos.dev
[kromgo_url]: https://github.com/kashalls/kromgo
