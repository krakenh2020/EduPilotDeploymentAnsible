# KRAKEN Education Pilot - Demo Deployment (Ansible)

Deployment of all server components needed to operate the demonstrator of an university credential exporter.

Part of the [**H2020 Project KRAKEN**](https://krakenh2020.eu/) and the [**Verifiable Credentials for Student Mobility**](https://api.ltb.io/show/BLUOR) project funded by TU Graz as a technologically enhanced administration (TEA) marketplace project.

---

For local test/evaluation deployments we recommend our [Docker Deployment](https://github.com/krakenh2020/EduPilotDeploymentDocker) instead.

---

## Deployment

* Adapt inventory (in `hosts`) and SSH config (`ssh/config`) to your setup
* Adapt variables in `host_vars/kraken/main.yml` to your deployment


### Playbooks

Use `ansible-playbook` to apply the following playbooks:

* `play_ping.yml`: Test connection to server(s)
* `play_infra.yml`: Setup certbot and nginx
* `play_agents.yml`: Setup two aries agents (for university and student) and nginx reverse-proxies for the inbound connections
  * Uses the ansible role in `roles/aries_agent`
  * Agents' inbound available at host configured via `agent_student_domain`
* `play_api.yml`: Setup university API and nginx reverse-proxy for it
  * API available at host configured via `api_domain`
* `play_frontend.yml`: Setup university frontend (connector) and nginx reverye proxy for it
  * Frontend available at host configured via `frontend_domain`


## Services

* [Connector (Frontend)](https://github.com/krakenh2020/EduPilotFrontend) [![Build, Test, Deploy](https://github.com/krakenh2020/EduPilotPrototype1/actions/workflows/test-and-deploy.yml/badge.svg)](https://github.com/krakenh2020/EduPilotPrototype1/actions/workflows/test-and-deploy.yml)
* [API Platform (Backend)](https://github.com/krakenh2020/EduPilotBackend) [![Build, Deploy](https://github.com/krakenh2020/EduPilotBackend/actions/workflows/docker.yml/badge.svg)](https://github.com/krakenh2020/EduPilotBackend/actions/workflows/docker.yml)
  * [API Backend Implementation](https://github.com/krakenh2020/EduPilotBackendBundle)
* [Hyperledger Aries Agent](https://github.com/hyperledger/aries-framework-go)
* Sidetree: *TODO*


## Exposed Services

Several components are only reachable from localhost (on the ports configured in `host_vars/kraken/main.yml`).
Only the following services are exposed to the internet (their hostname depend on the `nginx_zone` variable):

* University connector: `"kraken-edu.{{ nginx_zone }}"`
* University API: `"kraken-edu-api.{{ nginx_zone }}"`
* University Aries Agent: (with TLS)
    - API: *not exposed*
    - Inbound: `"kraken-edu-university.{{ nginx_zone }}"`
    - Webhook: *not exposed*
* Student Aries Agent: (no TLS)
    - API: *not exposed*
    - Inbound: `"kraken-edu-student.{{ nginx_zone }}"`
    - Webhook: *not exposed*


### To test [mobile wallet](https://scm.atosresearch.eu/ari/kraken/ssi-ledgeruself-mobile) of student:

... you need to run a aries agent for the student and use it's hostname (see [Docker Deployment](https://github.com/krakenh2020/EduPilotDeploymentDocker)) 
or adapt the deployment to expose the student agent's API (running on port configured in `agent_student_port_api`).