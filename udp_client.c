#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>

#define PORT_SERV 8888
#define BUFF_LEN 256

typedef struct msg{
    unsigned int seq;
}msg;

msg buff;
char filename[] = "buf.txt";
static void udpclie(int s, struct sockaddr *to)
{
//    msg buff;
    struct sockaddr_in from;
    socklen_t len = sizeof(*to);
    unsigned int n = 0;
    int file, flag;
    char seq[10];
    file = open(filename, O_RDWR | O_CREAT, S_IRWXU);
    if (file == -1) {
        printf("File %s exist!, reopen it", filename);
        file = open(filename, O_RDWR);
        printf("file: %d\n", file);
    } else
        printf("Open file %s succeed, file %d\n", filename, file);
    while (1) {
        n++;
	    n = n % 25535;
        buff.seq = n; 
        sendto(s, &buff, sizeof(buff), 0, to, len);
	printf("send:%d\n", buff.seq);
        flag = recvfrom(s, &buff, sizeof(buff), 0, (struct sockaddr*)&from, &len);
	if (flag == -1 && errno != EAGAIN) {
	    perror("recv failed\n");
            exit(1);
	} else if (flag == 0 || (flag == -1 && errno == EAGAIN)) {
	    sleep(1);
 	    continue;
    	} else {
	    printf("recv:%d\n", buff.seq);
	    sprintf(seq, "%d\n", buff.seq);
	    write(file, seq, strlen(seq));
	}  
        sleep(1);
    }
    close(file);
    
} 

int main(int argc, char *argv[])
{
    if (argc != 2) {
	printf("the argument is not 2\n");
	return 0;
    }
    int s;   // the client socket
    struct sockaddr_in addr_serv;
    int flag;

    s = socket(AF_INET, SOCK_DGRAM, 0);
    flag = fcntl(s, F_GETFL, 0);
    if (flag < 0) {
        perror("socket failed\n");
        exit(0);
    }
    flag |= O_NONBLOCK;
    if (fcntl(s, F_SETFL, flag) < 0) {
	perror("fcntl failed\n");
	exit(1);
    }
    memset(&addr_serv, 0, sizeof(addr_serv));
    addr_serv.sin_family = AF_INET;
    addr_serv.sin_addr.s_addr = htonl(INADDR_ANY);
    addr_serv.sin_port = htons(PORT_SERV);
    inet_pton(AF_INET, argv[1], &addr_serv.sin_addr);
    udpclie(s, (struct sockaddr *)&addr_serv);
    close(s);
    return 0;
}
