import socket
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('192.168.1.10', 8080))
client.send("I AM CLIENT<br>".encode())
from_server = client.recv(4096)
client.close()
print(from_server)

