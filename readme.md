<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD033 -->
<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br/>
<div align="center">
  <a href="https://github.com/snoopy82481/home_cluster">
    <img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" alt="home_cluster" width="144" height="144">
  </a>

<h3 align="center">My home Kubernetes cluster</h3>

  <p align="center">
    _... managed by Flux and serviced with RenovateBot_ :robot:
    <br/>
    <a href="https://github.com/snoopy82481/home_cluster"><strong>Explore the docs »</strong></a>
    <br/>
    <!-- PROJECT SHIELDS-->
    <div id="project_shields">
      ![License][license-shield]
      ![GitHub Workflow Status][workflow-shield]
      [![Pre-commit][pre-commit-shield]][pre-comit-url]
      ![Last-commit][last-commit-shield]
      [![OS][os-sheild]][os-url]
    </div>
    <br/>
    <a href="https://github.com/snoopy82481/home_cluster/issues/new?template=bug-report.yaml">Report Bug</a>
    ·
    <a href="https://github.com/snoopy82481/home_cluster/issues/new?template=feature-request.yaml">Request Feature</a>
  </p>
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
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This repo is in major disarray at the moment.  I am currently refactoring my existing repo [new_template_k3s][old_repo_url].

This is a complete rework of my existing cluster, that I tend to learn [Talos Linux](https://www.talos.dev) with.

The cluster is managed by [Renovatebot](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) and [flux](https://toolkit.fluxcd.io/) for automation of most of the process. Except the actual deployment configurations.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* [![Kubernetes][kubernetes_shield]][kubernetes_url]
* [![RenovateBot][renovatebot_shield]][renovatebot_url]
* [![Flux][flux_shield]][flux_url]
* [![Talos][talos_shield]][talos_url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

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
   git clone https://github.com/github_username/repo_name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```js
   const API_KEY = 'ENTER YOUR API';
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

* [x] Talos Config
* [x] Cilium CNI
* [ ] Documentation
    * [x] Create README.md
    * [ ] Document workflow (Github Pages/Cloudflare pages)

See the [open issues](https://github.com/github_username/repo_name/issues) for a full list of proposed features (and known issues).

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
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email@email_client.com

Project Link: [https://github.com/snoopy82481/home_cluster](https://github.com/snoopy82481/home_cluster)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

A lot of my insperation came from multiple users part of the k8s-at-home community
There is a lot of code jacking from:

* [@onedr0p](https://github.com/onedr0p)
* [@bjw-s](https://github.com/bjw-s)
* [@Truxnell](https://github.com/Truxnell)
* [@xUnholy](https://github.com/xUnholy)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
[license-shield]: https://img.shields.io/github/license/snoopy82481/home_cluster?style=for-the-badge
[workflow-shield]: https://img.shields.io/github/workflow/status/snoopy82481/home_cluster/Schedule:%20Renovate?color=informational&label=%20&logo=renovatebot&style=for-the-badge
[pre-commit-shield]: https://img.shields.io/badge/pre--commit-enabled-blue?logo=pre-commit&logoColor=white&label&style=for-the-badge
[pre-comit-url]: https://github.com/pre-commit/pre-commit
[last-commit-shield]: https://img.shields.io/github/last-commit/snoopy82481/home_cluster/master?style=for-the-badge
[os-sheild]: https://img.shields.io/badge/OS-Talos-informational?style=for-the-badge
[os-url]: https://talos.dev
[old_repo_url]: https://github.com/snoopy82481/new_template_k3s
[kubernetes_shield]: https://img.shields.io/badge/kubernetes-4A4A55?style=for-the-badge&logo=kubernetes&logoColor=white
[kubernetes_url]: https://kubernetes.io
[renovatebot_shield]: https://img.shields.io/badge/Renovatebot-4A4A55?style=for-the-badge&logo=renovatebot&logoColor=white
[renovatebot_url]: https://www.whitesourcesoftware.com/free-developer-tools/renovate/
[flux_shield]: https://img.shields.io/badge/Flux-4A4A55?style=for-the-badge&logo=flux&logoColor=white
[flux_url]: https://fluxcd.io
[talos_shield]: https://img.shields.io/badge/Talos-4A4A55?style=for-the-badge
[talos_url]: https://www.talos.dev
