from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.compute import Server
from diagrams.onprem.network import Internet, Pfsense
from diagrams.onprem.proxmox import Pve
from diagrams.onprem.iac import Terraform
from diagrams.onprem.container import LXC
from diagrams.generic.network import Router, Switch
from diagrams.generic.os import LinuxGeneral, IOS, Android, Windows
from diagrams.generic.blank import Blank
from diagrams.custom import Custom

vlan0: Edge = Edge(color="purple")
vlan10_mgmt: Edge = Edge(color="darkorange")
vlan20_server: Edge = Edge(color="lightblue")
vlan30_iot: Edge = Edge(color="black")
vlan40_guest: Edge = Edge(color="darkred")
vlan50_trusted: Edge = Edge(color="darkgreen")
internet: Edge = Edge(color="black", style="bold")
trunk: Edge = Edge(color="firebrick", style="dashed")

with Diagram("Network Map", show=False, filename="network_map", direction="TB", strict=True):

    source:Internet = Internet("Internet")

    modem:Router = Router("NETGEAR Nighthawk Cable Modem CM1200")


    with Cluster("Proxmox Host (Dell PowerEdge R520)"):
        proxmox: Pve = Pve("Proxmox")
        idrac:Blank = Blank("Dell idrac")

        with Cluster("VM"):
            pfsense: Pfsense = Pfsense("pfSense")
            with Cluster("Vlan20"):
                truenas: Custom = Custom("TrueNAS", "./truenas_open_storage-logo-full-color-rgb.png")
                devbox:LinuxGeneral = LinuxGeneral("Devbox")

                with Cluster("Kubernetes Cluster"):
                    talos_master_nodes: list[Custom] = [Custom(f"kmaster{i+1}", "talos_logo.svg") for i in range(3)]
                    talos_worker_nodes: list[Custom] = [Custom(f"kworker{i+1}", "talos_logo.svg") for i in range(3)]

                with Cluster("LXC"):
                    omada_controller: LXC = LXC("Omada Controller")


    # with Cluster("VLan0"):
    with Cluster("Mobile Devices"):
        stephen_iphone: IOS = IOS("Stephen iPhone 16 Pro")
        becky_iphone: IOS = IOS("Becky iPhone 13 Pro")
        chris_iphone: IOS = IOS("Chris iPhone 15")
        alex_iphone: IOS = IOS("Alex iPhone SE")
        chris_ipad: IOS = IOS("Chris iPad")
        alex_ipad: IOS = IOS("Alex iPad")
        sherleyMD: Android = Android("Sherley S23")


    with Cluster("TV/Entertainment"):
        receiver:Blank = Blank("Yamaha RX-V683")
        nintendo_switch:Blank =  Blank("Nintendo Switch")
        playstation:Blank = Blank("Playstation 4")
        lgc1:Blank = Blank("LG C1 TV bonusroom")
        sherleyTV:Blank = Blank("LG TV Sherley")


    with Cluster("Computers"):
        kidsfunPC:Windows = Windows("Kidsfun")
        sherleyPC:Windows = Windows("Sherley")
        stephenmac:IOS = IOS("Stephen Macbook Pro")
        stephenPC:Windows = Windows("Stephen PC")


    with Cluster("3D Printers"):
        bl_x1c: Custom = Custom("Bambu Lab X1 Carbon", "bl_logo.png")
        bl_p1p: Custom = Custom("Bambu Lab P1P", "bl_logo.png")
        bl_p1s: Custom = Custom("Bambu Lab P1S", "bl_logo.png")


    with Cluster("Vlan10"):
        main_switch:Switch = Switch("Cisco WS-C3650-48PD")
        sub_switch:Switch = Switch("Cisco CBS350")

        with Cluster("Wireless Access Points\nTP-Link EAP660 HD V1"):
            ap_living:Router = Router("Living Room")
            ap_uphall:Router = Router("Upstairs Hall")
            ap_bonus:Router = Router("Bonus Room")


    aps = [ap_bonus,ap_living,ap_uphall]
    personal_md = [stephen_iphone,becky_iphone,chris_ipad,chris_ipad,alex_ipad,alex_iphone, sherleyMD]
    tv: list[Blank] = [lgc1,sherleyTV]


    source >> internet << modem
    modem >> internet << pfsense
    pfsense >> trunk << main_switch

    main_switch >> trunk << aps
    main_switch >> trunk << idrac
    main_switch >> trunk << sub_switch

    main_switch >> vlan0 << proxmox
    main_switch >> vlan0 << lgc1
    main_switch >> vlan0 << kidsfunPC
    main_switch >> vlan0 << playstation

    aps >> vlan0 << nintendo_switch
    aps >> vlan0 << sherleyPC
    aps >> vlan0 << sherleyTV
    aps >> vlan0 << stephenmac
    aps >> vlan0 << stephen_iphone
    aps >> vlan0 << becky_iphone
    aps >> vlan0 << chris_iphone
    aps >> vlan0 << alex_iphone
    aps >> vlan0 << chris_ipad
    aps >> vlan0 << alex_ipad
    aps >> vlan0 << sherleyMD
    aps >> vlan0 << bl_x1c
    aps >> vlan0 << bl_p1p
    aps >> vlan0 << bl_p1s

    sub_switch >> vlan50_trusted << stephenPC
    sub_switch >> vlan50_trusted << stephenmac

