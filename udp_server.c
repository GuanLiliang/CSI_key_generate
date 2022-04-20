#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#define PORT_SERV 8888
#define BUFF_LEN 256

typedef struct msg
{
    /* data */
    int seq;
}msg;

char filename[] = "buff.txt";
void static udpserv(int s, struct sockaddr* client)
{
    int n;  // the len of data
    int len_file;
    int file;
    char seq[10];
    file = open(filename, O_RDWR | O_CREAT, S_IRWXU);
    if (file == -1) {
        printf("File %s exist!, reopen it", filename);
        file = open(filename, O_RDWR);
        printf("file: %d\n", file);
    } else 
        printf("Open file %s succeed, file %d\n", filename, file);
    msg buff;
    socklen_t len;
    while(1) {
        len = sizeof(*client);
        n = recvfrom(s, &buff, sizeof(buff), 0, client, &len);
        printf("recved: %d\n", buff.seq);
        sprintf(seq, "%d\n", buff.seq);
        write(file, seq, strlen(seq));
//        buff.seq++;
        sendto(s, &buff, n, 0, client, len);
        printf("send:%d\n", buff.seq);
//        if (buff.seq == 5) 
//	    break;
    }
    close(file);
}

int main(int argc, char *argv[])
{
    int s;   //  the server socket 
    struct sockaddr_in addr_serv, addr_clie;

    s = socket(AF_INET, SOCK_DGRAM, 0);

    memset(&addr_serv, 0, sizeof(addr_serv));
    addr_serv.sin_family = AF_INET;
    addr_serv.sin_addr.s_addr = htonl(INADDR_ANY);
    addr_serv.sin_port = htons(PORT_SERV);

    bind(s, (struct sockaddr*)&addr_serv, sizeof(addr_serv));

    udpserv(s, (struct sockaddr *)&addr_clie);
    return 0; 
}
