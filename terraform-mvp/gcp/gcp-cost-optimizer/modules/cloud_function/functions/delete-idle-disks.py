import google.auth
from googleapiclient.discovery import build

def main(request):
    credentials, project = google.auth.default()
    service = build('compute', 'v1', credentials=credentials)

    zones_request = service.zones().list(project=project)
    zones = [zone['name'] for zone in zones_request.execute().get('items', [])]

    for zone in zones:
        request = service.disks().list(project=project, zone=zone)
        response = request.execute()

        for disk in response.get('items', []):
            if disk.get('users') is None:
                print(f"Deleting unused disk: {disk['name']} in zone {zone}")
                delete_request = service.disks().delete(project=project, zone=zone, disk=disk['name'])
                delete_request.execute()

    return 'Idle disks deleted successfully'
