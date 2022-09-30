from diagrams import Cluster, Diagram, Edge
from diagrams.generic.network import Router, Switch
from diagrams.generic.os import Ubuntu, LinuxGeneral
from diagrams.onprem.network import Internet, Pfsense
from diagrams.onprem.proxmox import Pve
from diagrams.custom import Custom

with Diagram("Network Map", show=False):

    source = Internet("Internet")

    with Cluster("local"):
        with Cluster("Hardware"):
          modem = Router("NETGEAR Nighthawk Cable Modem CM1200")
          ap = Router("ASUS RT-AC68U Wireless Router")
          switch = Switch("NETGEAR 16-Port Gigabit Ethernet Plus Switch (GS116E)")
          proxmox = Pve("Proxmox Host")

        with Cluster("Proxmox\n192.168.0.101"):
          pfsense = Pfsense("pfSense")
          devbox = Ubuntu("devbox")
          truenas = Custom("TrueNAS", "truenas_open_storage-logo-full-color-rgb.png")
          kmaster1 = Custom("kmaster1 - TalosOS", "talos_logo.svg")
          kmaster2 = Custom("kmaster2 - TalosOS", "talos_logo.svg")
          kmaster3 = Custom("kmaster3 - TalosOS", "talos_logo.svg")
          kworker1 = Custom("kworker1 - TalosOS", "talos_logo.svg")
          kworker2 = Custom("kworker2 - TalosOS", "talos_logo.svg")
          kworker3 = Custom("kworker3 - TalosOS", "talos_logo.svg")

    source >> modem >> pfsense >> switch >> ap
    switch >> proxmox
