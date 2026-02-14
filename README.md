graph TD
    subgraph Internet_Zone [External Access]
        CF[Cloudflare Proxy] -->|Port 443| ISP[ISP Router]
    end

    subgraph Baires_Node [Proxmox Host: Baires]
        direction TB
        GW[Baires Networking / Gateway<br/>vmbr1 + vmbr0]
        
        subgraph Baires_LXC [LXC Layer]
            TR[Traefik Proxy LXC]
            DDNS[Cloudflare DDNS LXC]
            N8N[n8n Automation LXC]
            HOME[Homepage LXC]
        end
    end

    subgraph Madrid_Node [Proxmox Host: Madrid]
        direction TB
        
        subgraph Madrid_VMs [VM Layer]
            DSW[Docker Swarm VM]
            K8S[Kubernetes Cluster VMs]
        end
    end

    %% External to Gateway
    ISP -->|NAT/Forward| GW
    
    %% Traffic Distribution from Traefik
    TR -->|Local Proxy| N8N
    TR -->|Local Proxy| HOME
    TR -.->|2.5G Backplane Discovery| DSW
    TR -.->|2.5G Backplane Discovery| K8S

    %% Physical Link
    GW <===>|Direct 2.5G Link| Madrid_Node

    %% Styling
    style TR fill:#f96,stroke:#333,stroke-width:2px
    style GW fill:#bbf,stroke:#333
    style DSW fill:#dfd,stroke:#333
    style K8S fill:#dfd,stroke:#333
