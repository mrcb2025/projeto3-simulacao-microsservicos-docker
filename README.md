# Projeto de Simulação de Microsserviços com Docker Swarm, MySQL e Nginx
[![Linux](https://img.shields.io/badge/OS-Linux-blue?style=flat-square&logo=linux)](https://www.linux.org/)
[![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![MySQL](https://img.shields.io/badge/MySQL-00758F?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Docker Swarm](https://img.shields.io/badge/Docker_Swarm-62A1EB?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/engine/swarm/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)](https://www.nginx.com/)

Este projeto prático foi desenvolvido em resposta ao desafio proposto no Curso Linux-DIO.me, que explicitamente permitia replicar o projeto original **ou apresentar melhorias e evoluções**. Então, optei pela segunda proposta.

**Abordagem e Justificativa para a "Melhoria":**

Em vez de simplesmente replicar essa arquitetura, optei por explorar um paradigma mais moderno e escalável: a arquitetura de microsserviços, **entendendo que o desafio nos dava a liberdade de "melhorar" o projeto base.** Acredito que esta abordagem representa uma "melhoria", uma evolução ao demonstrar a capacidade de conceber e simular um sistema distribuído, que é uma prática cada vez mais comum no desenvolvimento de aplicações complexas.

O projeto original ([link para o repositório toshiro-shibakita](https://github.com/denilsonbonatti/toshiro-shibakita)) demonstra a conteinerização de uma aplicação PHP monolítica com um banco de dados MySQL e um servidor Nginx.

**Este projeto simula uma arquitetura de microsserviços utilizando:**

* **Docker:** Para a conteinerização dos serviços.
* **Docker Swarm:** Como uma plataforma de orquestração de containers (demonstrando a intenção de gerenciar múltiplos serviços).
* **Nginx:** Como um proxy reverso, responsável por receber as requisições dos clientes e roteá-las para os serviços apropriados (simulados).

Apesar de utilizarmos imagens base genéricas (`python:slim`, `node:alpine`, `openjdk:slim`) para simular os serviços (usuarios-api, catalogo-api, pedidos-api), o objetivo principal foi demonstrar a estrutura e o fluxo de uma arquitetura de microsserviços, onde diferentes partes da aplicação são independentes e se comunicam através de uma rede.

Acredito que esta abordagem, embora diferente da replicação direta do projeto original, demonstra uma compreensão mais aprofundada de conceitos avançados de arquitetura de software e o potencial do Docker em cenários mais complexos e escaláveis.

O script `projeto3.sh` implementa essa simulação, criando os serviços e configurando o Nginx para o roteamento básico.

**Como usar:**

1.  **Clone este repositório:** `git clone <URL_DO_SEU_REPOSITORIO>`
2.  **Navegue até o diretório do projeto:** `cd <nome_do_diretorio_do_repositorio>`
3.  **Execute o script de simulação:** `bash projeto3.sh`

    Este script irá tentar criar os diretórios, grupos de usuários (se não existirem), simular a criação de serviços Docker Swarm e configurar o Nginx para rotear o tráfego para esses serviços (na porta 80 da sua máquina virtual).
4.  **Acesse os serviços simulados (opcional):** Abra seu navegador e tente acessar os seguintes URLs (substituindo `10.0.0.106` pelo IP da sua VM, se necessário):
    * `http://10.0.0.106/usuarios/`
    * `http://10.0.0.106/catalogo/`
    * `http://10.0.0.106/pedidos/`

    Você provavelmente verá uma resposta "404 Not Found" do Nginx, o que indica que o roteamento está funcionando, mas não há aplicações reais respondendo nesses caminhos nas imagens base genéricas utilizadas na simulação.

**Observações:**

* Este projeto é uma **simulação** de uma arquitetura de microsserviços para fins de aprendizado e demonstração de conceitos. Não implementa funcionalidades completas dos serviços.
* A inicialização do Docker Swarm no script foi comentada devido a possíveis problemas de configuração de rede na VM, mas a intenção de usar o Swarm para orquestração está presente na lógica do script.
* A configuração do Nginx pode ser adaptada no arquivo `/etc/nginx/conf.d/default.conf` dentro do container `proxy-nginx` (se você optar por usar a versão containerizada) ou diretamente no arquivo configurado pelo script na VM.
* A criação e configuração de um container MySQL (`db-app`) foram incluídas no escopo do projeto, reconhecendo a necessidade de um banco de dados em uma arquitetura real de microsserviços.
* Nosso script atual não envolve a implantação na AWS. No entanto, a estrutura que criei (microsserviços em Docker, gerenciados por Swarm e expostos por um proxy reverso) é uma arquitetura que poderia ser implantada na AWS usando serviços como ECS (Elastic Container Service) ou EKS (Elastic Kubernetes Service), e o Nginx poderia ser substituído por um Application Load Balancer (ALB).
  
**Conclusão:**

Este projeto demonstra uma abordagem para a implementação de uma arquitetura de microsserviços utilizando Docker e suas ferramentas de orquestração e proxy reverso. Ao optar por simular essa arquitetura em vez de replicar diretamente a aplicação monolítica do projeto original, o objetivo foi apresentar uma compreensão de conceitos mais avançados e a capacidade de aplicar o Docker em cenários de sistemas distribuídos e escaláveis.

## Autor

Monica Campos
