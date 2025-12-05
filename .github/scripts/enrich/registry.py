from .providers import bjw_helm, cloudflared, kubernetes, qbittorrent, spegel
from .special_class import Provider

PROVIDERS: dict[str, Provider] = {
    "cloudflare/cloudflared": cloudflared.provider,
    "spegel-org/spegel": spegel.provider,
    "qbittorrent/qbittorrent": qbittorrent.provider,
    "bjw-s-labs/common": bjw_helm.provider,
    "kubernetes/kubernetes": kubernetes.provider,
}
