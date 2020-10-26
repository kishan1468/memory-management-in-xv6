
_mkdir:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fb          	endbr32 
    1004:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1008:	83 e4 f0             	and    $0xfffffff0,%esp
    100b:	ff 71 fc             	pushl  -0x4(%ecx)
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	57                   	push   %edi
    1012:	bf 01 00 00 00       	mov    $0x1,%edi
    1017:	56                   	push   %esi
    1018:	53                   	push   %ebx
    1019:	51                   	push   %ecx
    101a:	83 ec 08             	sub    $0x8,%esp
    101d:	8b 59 04             	mov    0x4(%ecx),%ebx
    1020:	8b 31                	mov    (%ecx),%esi
    1022:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
    1025:	83 fe 01             	cmp    $0x1,%esi
    1028:	7e 3a                	jle    1064 <main+0x64>
    102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	ff 33                	pushl  (%ebx)
    1035:	e8 11 03 00 00       	call   134b <mkdir>
    103a:	83 c4 10             	add    $0x10,%esp
    103d:	85 c0                	test   %eax,%eax
    103f:	78 0f                	js     1050 <main+0x50>
  for(i = 1; i < argc; i++){
    1041:	83 c7 01             	add    $0x1,%edi
    1044:	83 c3 04             	add    $0x4,%ebx
    1047:	39 fe                	cmp    %edi,%esi
    1049:	75 e5                	jne    1030 <main+0x30>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
    104b:	e8 93 02 00 00       	call   12e3 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
    1050:	50                   	push   %eax
    1051:	ff 33                	pushl  (%ebx)
    1053:	68 ff 17 00 00       	push   $0x17ff
    1058:	6a 02                	push   $0x2
    105a:	e8 e1 03 00 00       	call   1440 <printf>
      break;
    105f:	83 c4 10             	add    $0x10,%esp
    1062:	eb e7                	jmp    104b <main+0x4b>
    printf(2, "Usage: mkdir files...\n");
    1064:	52                   	push   %edx
    1065:	52                   	push   %edx
    1066:	68 e8 17 00 00       	push   $0x17e8
    106b:	6a 02                	push   $0x2
    106d:	e8 ce 03 00 00       	call   1440 <printf>
    exit();
    1072:	e8 6c 02 00 00       	call   12e3 <exit>
    1077:	66 90                	xchg   %ax,%ax
    1079:	66 90                	xchg   %ax,%ax
    107b:	66 90                	xchg   %ax,%ax
    107d:	66 90                	xchg   %ax,%ax
    107f:	90                   	nop

00001080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1080:	f3 0f 1e fb          	endbr32 
    1084:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1085:	31 c0                	xor    %eax,%eax
{
    1087:	89 e5                	mov    %esp,%ebp
    1089:	53                   	push   %ebx
    108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    108d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1090:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1094:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1097:	83 c0 01             	add    $0x1,%eax
    109a:	84 d2                	test   %dl,%dl
    109c:	75 f2                	jne    1090 <strcpy+0x10>
    ;
  return os;
}
    109e:	89 c8                	mov    %ecx,%eax
    10a0:	5b                   	pop    %ebx
    10a1:	5d                   	pop    %ebp
    10a2:	c3                   	ret    
    10a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000010b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b0:	f3 0f 1e fb          	endbr32 
    10b4:	55                   	push   %ebp
    10b5:	89 e5                	mov    %esp,%ebp
    10b7:	53                   	push   %ebx
    10b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    10be:	0f b6 01             	movzbl (%ecx),%eax
    10c1:	0f b6 1a             	movzbl (%edx),%ebx
    10c4:	84 c0                	test   %al,%al
    10c6:	75 19                	jne    10e1 <strcmp+0x31>
    10c8:	eb 26                	jmp    10f0 <strcmp+0x40>
    10ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10d0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    10d4:	83 c1 01             	add    $0x1,%ecx
    10d7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10da:	0f b6 1a             	movzbl (%edx),%ebx
    10dd:	84 c0                	test   %al,%al
    10df:	74 0f                	je     10f0 <strcmp+0x40>
    10e1:	38 d8                	cmp    %bl,%al
    10e3:	74 eb                	je     10d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    10e5:	29 d8                	sub    %ebx,%eax
}
    10e7:	5b                   	pop    %ebx
    10e8:	5d                   	pop    %ebp
    10e9:	c3                   	ret    
    10ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    10f2:	29 d8                	sub    %ebx,%eax
}
    10f4:	5b                   	pop    %ebx
    10f5:	5d                   	pop    %ebp
    10f6:	c3                   	ret    
    10f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10fe:	66 90                	xchg   %ax,%ax

00001100 <strlen>:

uint
strlen(char *s)
{
    1100:	f3 0f 1e fb          	endbr32 
    1104:	55                   	push   %ebp
    1105:	89 e5                	mov    %esp,%ebp
    1107:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    110a:	80 3a 00             	cmpb   $0x0,(%edx)
    110d:	74 21                	je     1130 <strlen+0x30>
    110f:	31 c0                	xor    %eax,%eax
    1111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1118:	83 c0 01             	add    $0x1,%eax
    111b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    111f:	89 c1                	mov    %eax,%ecx
    1121:	75 f5                	jne    1118 <strlen+0x18>
    ;
  return n;
}
    1123:	89 c8                	mov    %ecx,%eax
    1125:	5d                   	pop    %ebp
    1126:	c3                   	ret    
    1127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    112e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    1130:	31 c9                	xor    %ecx,%ecx
}
    1132:	5d                   	pop    %ebp
    1133:	89 c8                	mov    %ecx,%eax
    1135:	c3                   	ret    
    1136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    113d:	8d 76 00             	lea    0x0(%esi),%esi

00001140 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1140:	f3 0f 1e fb          	endbr32 
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	57                   	push   %edi
    1148:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    114b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    114e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1151:	89 d7                	mov    %edx,%edi
    1153:	fc                   	cld    
    1154:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1156:	89 d0                	mov    %edx,%eax
    1158:	5f                   	pop    %edi
    1159:	5d                   	pop    %ebp
    115a:	c3                   	ret    
    115b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    115f:	90                   	nop

00001160 <strchr>:

char*
strchr(const char *s, char c)
{
    1160:	f3 0f 1e fb          	endbr32 
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
    1167:	8b 45 08             	mov    0x8(%ebp),%eax
    116a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    116e:	0f b6 10             	movzbl (%eax),%edx
    1171:	84 d2                	test   %dl,%dl
    1173:	75 16                	jne    118b <strchr+0x2b>
    1175:	eb 21                	jmp    1198 <strchr+0x38>
    1177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    117e:	66 90                	xchg   %ax,%ax
    1180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1184:	83 c0 01             	add    $0x1,%eax
    1187:	84 d2                	test   %dl,%dl
    1189:	74 0d                	je     1198 <strchr+0x38>
    if(*s == c)
    118b:	38 d1                	cmp    %dl,%cl
    118d:	75 f1                	jne    1180 <strchr+0x20>
      return (char*)s;
  return 0;
}
    118f:	5d                   	pop    %ebp
    1190:	c3                   	ret    
    1191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1198:	31 c0                	xor    %eax,%eax
}
    119a:	5d                   	pop    %ebp
    119b:	c3                   	ret    
    119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011a0 <gets>:

char*
gets(char *buf, int max)
{
    11a0:	f3 0f 1e fb          	endbr32 
    11a4:	55                   	push   %ebp
    11a5:	89 e5                	mov    %esp,%ebp
    11a7:	57                   	push   %edi
    11a8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a9:	31 f6                	xor    %esi,%esi
{
    11ab:	53                   	push   %ebx
    11ac:	89 f3                	mov    %esi,%ebx
    11ae:	83 ec 1c             	sub    $0x1c,%esp
    11b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    11b4:	eb 33                	jmp    11e9 <gets+0x49>
    11b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11bd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    11c0:	83 ec 04             	sub    $0x4,%esp
    11c3:	8d 45 e7             	lea    -0x19(%ebp),%eax
    11c6:	6a 01                	push   $0x1
    11c8:	50                   	push   %eax
    11c9:	6a 00                	push   $0x0
    11cb:	e8 2b 01 00 00       	call   12fb <read>
    if(cc < 1)
    11d0:	83 c4 10             	add    $0x10,%esp
    11d3:	85 c0                	test   %eax,%eax
    11d5:	7e 1c                	jle    11f3 <gets+0x53>
      break;
    buf[i++] = c;
    11d7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11db:	83 c7 01             	add    $0x1,%edi
    11de:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    11e1:	3c 0a                	cmp    $0xa,%al
    11e3:	74 23                	je     1208 <gets+0x68>
    11e5:	3c 0d                	cmp    $0xd,%al
    11e7:	74 1f                	je     1208 <gets+0x68>
  for(i=0; i+1 < max; ){
    11e9:	83 c3 01             	add    $0x1,%ebx
    11ec:	89 fe                	mov    %edi,%esi
    11ee:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11f1:	7c cd                	jl     11c0 <gets+0x20>
    11f3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    11f5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    11f8:	c6 03 00             	movb   $0x0,(%ebx)
}
    11fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11fe:	5b                   	pop    %ebx
    11ff:	5e                   	pop    %esi
    1200:	5f                   	pop    %edi
    1201:	5d                   	pop    %ebp
    1202:	c3                   	ret    
    1203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1207:	90                   	nop
    1208:	8b 75 08             	mov    0x8(%ebp),%esi
    120b:	8b 45 08             	mov    0x8(%ebp),%eax
    120e:	01 de                	add    %ebx,%esi
    1210:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    1212:	c6 03 00             	movb   $0x0,(%ebx)
}
    1215:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1218:	5b                   	pop    %ebx
    1219:	5e                   	pop    %esi
    121a:	5f                   	pop    %edi
    121b:	5d                   	pop    %ebp
    121c:	c3                   	ret    
    121d:	8d 76 00             	lea    0x0(%esi),%esi

00001220 <stat>:

int
stat(char *n, struct stat *st)
{
    1220:	f3 0f 1e fb          	endbr32 
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	56                   	push   %esi
    1228:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1229:	83 ec 08             	sub    $0x8,%esp
    122c:	6a 00                	push   $0x0
    122e:	ff 75 08             	pushl  0x8(%ebp)
    1231:	e8 ed 00 00 00       	call   1323 <open>
  if(fd < 0)
    1236:	83 c4 10             	add    $0x10,%esp
    1239:	85 c0                	test   %eax,%eax
    123b:	78 2b                	js     1268 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    123d:	83 ec 08             	sub    $0x8,%esp
    1240:	ff 75 0c             	pushl  0xc(%ebp)
    1243:	89 c3                	mov    %eax,%ebx
    1245:	50                   	push   %eax
    1246:	e8 f0 00 00 00       	call   133b <fstat>
  close(fd);
    124b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    124e:	89 c6                	mov    %eax,%esi
  close(fd);
    1250:	e8 b6 00 00 00       	call   130b <close>
  return r;
    1255:	83 c4 10             	add    $0x10,%esp
}
    1258:	8d 65 f8             	lea    -0x8(%ebp),%esp
    125b:	89 f0                	mov    %esi,%eax
    125d:	5b                   	pop    %ebx
    125e:	5e                   	pop    %esi
    125f:	5d                   	pop    %ebp
    1260:	c3                   	ret    
    1261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1268:	be ff ff ff ff       	mov    $0xffffffff,%esi
    126d:	eb e9                	jmp    1258 <stat+0x38>
    126f:	90                   	nop

00001270 <atoi>:

int
atoi(const char *s)
{
    1270:	f3 0f 1e fb          	endbr32 
    1274:	55                   	push   %ebp
    1275:	89 e5                	mov    %esp,%ebp
    1277:	53                   	push   %ebx
    1278:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    127b:	0f be 02             	movsbl (%edx),%eax
    127e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1281:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1284:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1289:	77 1a                	ja     12a5 <atoi+0x35>
    128b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    128f:	90                   	nop
    n = n*10 + *s++ - '0';
    1290:	83 c2 01             	add    $0x1,%edx
    1293:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1296:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    129a:	0f be 02             	movsbl (%edx),%eax
    129d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    12a0:	80 fb 09             	cmp    $0x9,%bl
    12a3:	76 eb                	jbe    1290 <atoi+0x20>
  return n;
}
    12a5:	89 c8                	mov    %ecx,%eax
    12a7:	5b                   	pop    %ebx
    12a8:	5d                   	pop    %ebp
    12a9:	c3                   	ret    
    12aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000012b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12b0:	f3 0f 1e fb          	endbr32 
    12b4:	55                   	push   %ebp
    12b5:	89 e5                	mov    %esp,%ebp
    12b7:	57                   	push   %edi
    12b8:	8b 45 10             	mov    0x10(%ebp),%eax
    12bb:	8b 55 08             	mov    0x8(%ebp),%edx
    12be:	56                   	push   %esi
    12bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
    12c2:	85 c0                	test   %eax,%eax
    12c4:	7e 0f                	jle    12d5 <memmove+0x25>
    12c6:	01 d0                	add    %edx,%eax
  src = vsrc;
    12c8:	89 d7                	mov    %edx,%edi
    12ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return vdst;
    12d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    *dst++ = *src++;
    12d1:	39 f8                	cmp    %edi,%eax
    12d3:	75 fb                	jne    12d0 <memmove+0x20>
}
    12d5:	5e                   	pop    %esi
    12d6:	89 d0                	mov    %edx,%eax
    12d8:	5f                   	pop    %edi
    12d9:	5d                   	pop    %ebp
    12da:	c3                   	ret    

000012db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12db:	b8 01 00 00 00       	mov    $0x1,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <exit>:
SYSCALL(exit)
    12e3:	b8 02 00 00 00       	mov    $0x2,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <wait>:
SYSCALL(wait)
    12eb:	b8 03 00 00 00       	mov    $0x3,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <pipe>:
SYSCALL(pipe)
    12f3:	b8 04 00 00 00       	mov    $0x4,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <read>:
SYSCALL(read)
    12fb:	b8 05 00 00 00       	mov    $0x5,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <write>:
SYSCALL(write)
    1303:	b8 10 00 00 00       	mov    $0x10,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <close>:
SYSCALL(close)
    130b:	b8 15 00 00 00       	mov    $0x15,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <kill>:
SYSCALL(kill)
    1313:	b8 06 00 00 00       	mov    $0x6,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <exec>:
SYSCALL(exec)
    131b:	b8 07 00 00 00       	mov    $0x7,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <open>:
SYSCALL(open)
    1323:	b8 0f 00 00 00       	mov    $0xf,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <mknod>:
SYSCALL(mknod)
    132b:	b8 11 00 00 00       	mov    $0x11,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <unlink>:
SYSCALL(unlink)
    1333:	b8 12 00 00 00       	mov    $0x12,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <fstat>:
SYSCALL(fstat)
    133b:	b8 08 00 00 00       	mov    $0x8,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <link>:
SYSCALL(link)
    1343:	b8 13 00 00 00       	mov    $0x13,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <mkdir>:
SYSCALL(mkdir)
    134b:	b8 14 00 00 00       	mov    $0x14,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <chdir>:
SYSCALL(chdir)
    1353:	b8 09 00 00 00       	mov    $0x9,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <dup>:
SYSCALL(dup)
    135b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <getpid>:
SYSCALL(getpid)
    1363:	b8 0b 00 00 00       	mov    $0xb,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <sbrk>:
SYSCALL(sbrk)
    136b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <sleep>:
SYSCALL(sleep)
    1373:	b8 0d 00 00 00       	mov    $0xd,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <uptime>:
SYSCALL(uptime)
    137b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    
    1383:	66 90                	xchg   %ax,%ax
    1385:	66 90                	xchg   %ax,%ax
    1387:	66 90                	xchg   %ax,%ax
    1389:	66 90                	xchg   %ax,%ax
    138b:	66 90                	xchg   %ax,%ax
    138d:	66 90                	xchg   %ax,%ax
    138f:	90                   	nop

00001390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1390:	55                   	push   %ebp
    1391:	89 e5                	mov    %esp,%ebp
    1393:	57                   	push   %edi
    1394:	56                   	push   %esi
    1395:	53                   	push   %ebx
    1396:	83 ec 3c             	sub    $0x3c,%esp
    1399:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    139c:	89 d1                	mov    %edx,%ecx
{
    139e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    13a1:	85 d2                	test   %edx,%edx
    13a3:	0f 89 7f 00 00 00    	jns    1428 <printint+0x98>
    13a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    13ad:	74 79                	je     1428 <printint+0x98>
    neg = 1;
    13af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    13b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    13b8:	31 db                	xor    %ebx,%ebx
    13ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
    13bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    13c0:	89 c8                	mov    %ecx,%eax
    13c2:	31 d2                	xor    %edx,%edx
    13c4:	89 cf                	mov    %ecx,%edi
    13c6:	f7 75 c4             	divl   -0x3c(%ebp)
    13c9:	0f b6 92 24 18 00 00 	movzbl 0x1824(%edx),%edx
    13d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    13d3:	89 d8                	mov    %ebx,%eax
    13d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    13d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    13db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    13de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    13e1:	76 dd                	jbe    13c0 <printint+0x30>
  if(neg)
    13e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    13e6:	85 c9                	test   %ecx,%ecx
    13e8:	74 0c                	je     13f6 <printint+0x66>
    buf[i++] = '-';
    13ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    13ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    13f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    13f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    13f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    13fd:	eb 07                	jmp    1406 <printint+0x76>
    13ff:	90                   	nop
    1400:	0f b6 13             	movzbl (%ebx),%edx
    1403:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1406:	83 ec 04             	sub    $0x4,%esp
    1409:	88 55 d7             	mov    %dl,-0x29(%ebp)
    140c:	6a 01                	push   $0x1
    140e:	56                   	push   %esi
    140f:	57                   	push   %edi
    1410:	e8 ee fe ff ff       	call   1303 <write>
  while(--i >= 0)
    1415:	83 c4 10             	add    $0x10,%esp
    1418:	39 de                	cmp    %ebx,%esi
    141a:	75 e4                	jne    1400 <printint+0x70>
    putc(fd, buf[i]);
}
    141c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    141f:	5b                   	pop    %ebx
    1420:	5e                   	pop    %esi
    1421:	5f                   	pop    %edi
    1422:	5d                   	pop    %ebp
    1423:	c3                   	ret    
    1424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1428:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    142f:	eb 87                	jmp    13b8 <printint+0x28>
    1431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    143f:	90                   	nop

00001440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1440:	f3 0f 1e fb          	endbr32 
    1444:	55                   	push   %ebp
    1445:	89 e5                	mov    %esp,%ebp
    1447:	57                   	push   %edi
    1448:	56                   	push   %esi
    1449:	53                   	push   %ebx
    144a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    144d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1450:	0f b6 1e             	movzbl (%esi),%ebx
    1453:	84 db                	test   %bl,%bl
    1455:	0f 84 b4 00 00 00    	je     150f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    145b:	8d 45 10             	lea    0x10(%ebp),%eax
    145e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1461:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1464:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1466:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1469:	eb 33                	jmp    149e <printf+0x5e>
    146b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    146f:	90                   	nop
    1470:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1473:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1478:	83 f8 25             	cmp    $0x25,%eax
    147b:	74 17                	je     1494 <printf+0x54>
  write(fd, &c, 1);
    147d:	83 ec 04             	sub    $0x4,%esp
    1480:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1483:	6a 01                	push   $0x1
    1485:	57                   	push   %edi
    1486:	ff 75 08             	pushl  0x8(%ebp)
    1489:	e8 75 fe ff ff       	call   1303 <write>
    148e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1491:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1494:	0f b6 1e             	movzbl (%esi),%ebx
    1497:	83 c6 01             	add    $0x1,%esi
    149a:	84 db                	test   %bl,%bl
    149c:	74 71                	je     150f <printf+0xcf>
    c = fmt[i] & 0xff;
    149e:	0f be cb             	movsbl %bl,%ecx
    14a1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    14a4:	85 d2                	test   %edx,%edx
    14a6:	74 c8                	je     1470 <printf+0x30>
      }
    } else if(state == '%'){
    14a8:	83 fa 25             	cmp    $0x25,%edx
    14ab:	75 e7                	jne    1494 <printf+0x54>
      if(c == 'd'){
    14ad:	83 f8 64             	cmp    $0x64,%eax
    14b0:	0f 84 9a 00 00 00    	je     1550 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    14b6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    14bc:	83 f9 70             	cmp    $0x70,%ecx
    14bf:	74 5f                	je     1520 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14c1:	83 f8 73             	cmp    $0x73,%eax
    14c4:	0f 84 d6 00 00 00    	je     15a0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14ca:	83 f8 63             	cmp    $0x63,%eax
    14cd:	0f 84 8d 00 00 00    	je     1560 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    14d3:	83 f8 25             	cmp    $0x25,%eax
    14d6:	0f 84 b4 00 00 00    	je     1590 <printf+0x150>
  write(fd, &c, 1);
    14dc:	83 ec 04             	sub    $0x4,%esp
    14df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    14e3:	6a 01                	push   $0x1
    14e5:	57                   	push   %edi
    14e6:	ff 75 08             	pushl  0x8(%ebp)
    14e9:	e8 15 fe ff ff       	call   1303 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    14ee:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    14f1:	83 c4 0c             	add    $0xc,%esp
    14f4:	6a 01                	push   $0x1
    14f6:	83 c6 01             	add    $0x1,%esi
    14f9:	57                   	push   %edi
    14fa:	ff 75 08             	pushl  0x8(%ebp)
    14fd:	e8 01 fe ff ff       	call   1303 <write>
  for(i = 0; fmt[i]; i++){
    1502:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1506:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1509:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    150b:	84 db                	test   %bl,%bl
    150d:	75 8f                	jne    149e <printf+0x5e>
    }
  }
}
    150f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1512:	5b                   	pop    %ebx
    1513:	5e                   	pop    %esi
    1514:	5f                   	pop    %edi
    1515:	5d                   	pop    %ebp
    1516:	c3                   	ret    
    1517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    151e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1520:	83 ec 0c             	sub    $0xc,%esp
    1523:	b9 10 00 00 00       	mov    $0x10,%ecx
    1528:	6a 00                	push   $0x0
    152a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    152d:	8b 45 08             	mov    0x8(%ebp),%eax
    1530:	8b 13                	mov    (%ebx),%edx
    1532:	e8 59 fe ff ff       	call   1390 <printint>
        ap++;
    1537:	89 d8                	mov    %ebx,%eax
    1539:	83 c4 10             	add    $0x10,%esp
      state = 0;
    153c:	31 d2                	xor    %edx,%edx
        ap++;
    153e:	83 c0 04             	add    $0x4,%eax
    1541:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1544:	e9 4b ff ff ff       	jmp    1494 <printf+0x54>
    1549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1550:	83 ec 0c             	sub    $0xc,%esp
    1553:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1558:	6a 01                	push   $0x1
    155a:	eb ce                	jmp    152a <printf+0xea>
    155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1560:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1563:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1566:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1568:	6a 01                	push   $0x1
        ap++;
    156a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    156d:	57                   	push   %edi
    156e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1571:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1574:	e8 8a fd ff ff       	call   1303 <write>
        ap++;
    1579:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    157c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    157f:	31 d2                	xor    %edx,%edx
    1581:	e9 0e ff ff ff       	jmp    1494 <printf+0x54>
    1586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    158d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1590:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1593:	83 ec 04             	sub    $0x4,%esp
    1596:	e9 59 ff ff ff       	jmp    14f4 <printf+0xb4>
    159b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    159f:	90                   	nop
        s = (char*)*ap;
    15a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    15a3:	8b 18                	mov    (%eax),%ebx
        ap++;
    15a5:	83 c0 04             	add    $0x4,%eax
    15a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    15ab:	85 db                	test   %ebx,%ebx
    15ad:	74 17                	je     15c6 <printf+0x186>
        while(*s != 0){
    15af:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    15b2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    15b4:	84 c0                	test   %al,%al
    15b6:	0f 84 d8 fe ff ff    	je     1494 <printf+0x54>
    15bc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    15bf:	89 de                	mov    %ebx,%esi
    15c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    15c4:	eb 1a                	jmp    15e0 <printf+0x1a0>
          s = "(null)";
    15c6:	bb 1b 18 00 00       	mov    $0x181b,%ebx
        while(*s != 0){
    15cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    15ce:	b8 28 00 00 00       	mov    $0x28,%eax
    15d3:	89 de                	mov    %ebx,%esi
    15d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    15d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15df:	90                   	nop
  write(fd, &c, 1);
    15e0:	83 ec 04             	sub    $0x4,%esp
          s++;
    15e3:	83 c6 01             	add    $0x1,%esi
    15e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    15e9:	6a 01                	push   $0x1
    15eb:	57                   	push   %edi
    15ec:	53                   	push   %ebx
    15ed:	e8 11 fd ff ff       	call   1303 <write>
        while(*s != 0){
    15f2:	0f b6 06             	movzbl (%esi),%eax
    15f5:	83 c4 10             	add    $0x10,%esp
    15f8:	84 c0                	test   %al,%al
    15fa:	75 e4                	jne    15e0 <printf+0x1a0>
    15fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    15ff:	31 d2                	xor    %edx,%edx
    1601:	e9 8e fe ff ff       	jmp    1494 <printf+0x54>
    1606:	66 90                	xchg   %ax,%ax
    1608:	66 90                	xchg   %ax,%ax
    160a:	66 90                	xchg   %ax,%ax
    160c:	66 90                	xchg   %ax,%ax
    160e:	66 90                	xchg   %ax,%ax

00001610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1610:	f3 0f 1e fb          	endbr32 
    1614:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1615:	a1 1c 1b 00 00       	mov    0x1b1c,%eax
{
    161a:	89 e5                	mov    %esp,%ebp
    161c:	57                   	push   %edi
    161d:	56                   	push   %esi
    161e:	53                   	push   %ebx
    161f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1622:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1624:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1627:	39 c8                	cmp    %ecx,%eax
    1629:	73 15                	jae    1640 <free+0x30>
    162b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    162f:	90                   	nop
    1630:	39 d1                	cmp    %edx,%ecx
    1632:	72 14                	jb     1648 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1634:	39 d0                	cmp    %edx,%eax
    1636:	73 10                	jae    1648 <free+0x38>
{
    1638:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    163a:	8b 10                	mov    (%eax),%edx
    163c:	39 c8                	cmp    %ecx,%eax
    163e:	72 f0                	jb     1630 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1640:	39 d0                	cmp    %edx,%eax
    1642:	72 f4                	jb     1638 <free+0x28>
    1644:	39 d1                	cmp    %edx,%ecx
    1646:	73 f0                	jae    1638 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1648:	8b 73 fc             	mov    -0x4(%ebx),%esi
    164b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    164e:	39 fa                	cmp    %edi,%edx
    1650:	74 1e                	je     1670 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1652:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1655:	8b 50 04             	mov    0x4(%eax),%edx
    1658:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    165b:	39 f1                	cmp    %esi,%ecx
    165d:	74 28                	je     1687 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    165f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1661:	5b                   	pop    %ebx
  freep = p;
    1662:	a3 1c 1b 00 00       	mov    %eax,0x1b1c
}
    1667:	5e                   	pop    %esi
    1668:	5f                   	pop    %edi
    1669:	5d                   	pop    %ebp
    166a:	c3                   	ret    
    166b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    166f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1670:	03 72 04             	add    0x4(%edx),%esi
    1673:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1676:	8b 10                	mov    (%eax),%edx
    1678:	8b 12                	mov    (%edx),%edx
    167a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    167d:	8b 50 04             	mov    0x4(%eax),%edx
    1680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1683:	39 f1                	cmp    %esi,%ecx
    1685:	75 d8                	jne    165f <free+0x4f>
    p->s.size += bp->s.size;
    1687:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    168a:	a3 1c 1b 00 00       	mov    %eax,0x1b1c
    p->s.size += bp->s.size;
    168f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1692:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1695:	89 10                	mov    %edx,(%eax)
}
    1697:	5b                   	pop    %ebx
    1698:	5e                   	pop    %esi
    1699:	5f                   	pop    %edi
    169a:	5d                   	pop    %ebp
    169b:	c3                   	ret    
    169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000016a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16a0:	f3 0f 1e fb          	endbr32 
    16a4:	55                   	push   %ebp
    16a5:	89 e5                	mov    %esp,%ebp
    16a7:	57                   	push   %edi
    16a8:	56                   	push   %esi
    16a9:	53                   	push   %ebx
    16aa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    16b0:	8b 3d 1c 1b 00 00    	mov    0x1b1c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16b6:	8d 70 07             	lea    0x7(%eax),%esi
    16b9:	c1 ee 03             	shr    $0x3,%esi
    16bc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    16bf:	85 ff                	test   %edi,%edi
    16c1:	0f 84 a9 00 00 00    	je     1770 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16c7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    16c9:	8b 48 04             	mov    0x4(%eax),%ecx
    16cc:	39 f1                	cmp    %esi,%ecx
    16ce:	73 6d                	jae    173d <malloc+0x9d>
    16d0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    16d6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    16db:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    16de:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    16e5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    16e8:	eb 17                	jmp    1701 <malloc+0x61>
    16ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16f0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    16f2:	8b 4a 04             	mov    0x4(%edx),%ecx
    16f5:	39 f1                	cmp    %esi,%ecx
    16f7:	73 4f                	jae    1748 <malloc+0xa8>
    16f9:	8b 3d 1c 1b 00 00    	mov    0x1b1c,%edi
    16ff:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1701:	39 c7                	cmp    %eax,%edi
    1703:	75 eb                	jne    16f0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1705:	83 ec 0c             	sub    $0xc,%esp
    1708:	ff 75 e4             	pushl  -0x1c(%ebp)
    170b:	e8 5b fc ff ff       	call   136b <sbrk>
  if(p == (char*)-1)
    1710:	83 c4 10             	add    $0x10,%esp
    1713:	83 f8 ff             	cmp    $0xffffffff,%eax
    1716:	74 1b                	je     1733 <malloc+0x93>
  hp->s.size = nu;
    1718:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    171b:	83 ec 0c             	sub    $0xc,%esp
    171e:	83 c0 08             	add    $0x8,%eax
    1721:	50                   	push   %eax
    1722:	e8 e9 fe ff ff       	call   1610 <free>
  return freep;
    1727:	a1 1c 1b 00 00       	mov    0x1b1c,%eax
      if((p = morecore(nunits)) == 0)
    172c:	83 c4 10             	add    $0x10,%esp
    172f:	85 c0                	test   %eax,%eax
    1731:	75 bd                	jne    16f0 <malloc+0x50>
        return 0;
  }
}
    1733:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1736:	31 c0                	xor    %eax,%eax
}
    1738:	5b                   	pop    %ebx
    1739:	5e                   	pop    %esi
    173a:	5f                   	pop    %edi
    173b:	5d                   	pop    %ebp
    173c:	c3                   	ret    
    if(p->s.size >= nunits){
    173d:	89 c2                	mov    %eax,%edx
    173f:	89 f8                	mov    %edi,%eax
    1741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1748:	39 ce                	cmp    %ecx,%esi
    174a:	74 54                	je     17a0 <malloc+0x100>
        p->s.size -= nunits;
    174c:	29 f1                	sub    %esi,%ecx
    174e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1751:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1754:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1757:	a3 1c 1b 00 00       	mov    %eax,0x1b1c
}
    175c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    175f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1762:	5b                   	pop    %ebx
    1763:	5e                   	pop    %esi
    1764:	5f                   	pop    %edi
    1765:	5d                   	pop    %ebp
    1766:	c3                   	ret    
    1767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    176e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1770:	c7 05 1c 1b 00 00 20 	movl   $0x1b20,0x1b1c
    1777:	1b 00 00 
    base.s.size = 0;
    177a:	bf 20 1b 00 00       	mov    $0x1b20,%edi
    base.s.ptr = freep = prevp = &base;
    177f:	c7 05 20 1b 00 00 20 	movl   $0x1b20,0x1b20
    1786:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1789:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    178b:	c7 05 24 1b 00 00 00 	movl   $0x0,0x1b24
    1792:	00 00 00 
    if(p->s.size >= nunits){
    1795:	e9 36 ff ff ff       	jmp    16d0 <malloc+0x30>
    179a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    17a0:	8b 0a                	mov    (%edx),%ecx
    17a2:	89 08                	mov    %ecx,(%eax)
    17a4:	eb b1                	jmp    1757 <malloc+0xb7>
    17a6:	66 90                	xchg   %ax,%ax
    17a8:	66 90                	xchg   %ax,%ax
    17aa:	66 90                	xchg   %ax,%ax
    17ac:	66 90                	xchg   %ax,%ax
    17ae:	66 90                	xchg   %ax,%ax

000017b0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    17b0:	f3 0f 1e fb          	endbr32 
    17b4:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    17b5:	b9 01 00 00 00       	mov    $0x1,%ecx
    17ba:	89 e5                	mov    %esp,%ebp
    17bc:	8b 55 08             	mov    0x8(%ebp),%edx
    17bf:	90                   	nop
    17c0:	89 c8                	mov    %ecx,%eax
    17c2:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    17c5:	85 c0                	test   %eax,%eax
    17c7:	75 f7                	jne    17c0 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    17c9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    17ce:	5d                   	pop    %ebp
    17cf:	c3                   	ret    

000017d0 <urelease>:

void urelease (struct uspinlock *lk) {
    17d0:	f3 0f 1e fb          	endbr32 
    17d4:	55                   	push   %ebp
    17d5:	89 e5                	mov    %esp,%ebp
    17d7:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    17da:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    17df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    17e5:	5d                   	pop    %ebp
    17e6:	c3                   	ret    
