
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 73 10 80       	push   $0x80107320
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 a1 43 00 00       	call   80104400 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 73 10 80       	push   $0x80107327
80100097:	50                   	push   %eax
80100098:	e8 53 42 00 00       	call   801042f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 23 44 00 00       	call   80104510 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 d9 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 41 00 00       	call   80104330 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 2f 21 00 00       	call   801022c0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 73 10 80       	push   $0x8010732e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 09 42 00 00       	call   801043d0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 e3 20 00 00       	jmp    801022c0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 73 10 80       	push   $0x8010733f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 c8 41 00 00       	call   801043d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 41 00 00       	call   80104390 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 ec 42 00 00       	call   80104510 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 43 00 00       	jmp    80104640 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 73 10 80       	push   $0x80107346
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 d6 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 5a 42 00 00       	call   80104510 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 86 3c 00 00       	call   80103f70 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 36 00 00       	call   801039b0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 2d 43 00 00       	call   80104640 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 84 14 00 00       	call   801017a0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 d6 42 00 00       	call   80104640 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 2d 14 00 00       	call   801017a0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 2e 25 00 00       	call   801028e0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 73 10 80       	push   $0x8010734d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 30 7d 10 80 	movl   $0x80107d30,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 73 10 80       	push   $0x80107361
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 61 59 00 00       	call   80105d90 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 76 58 00 00       	call   80105d90 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 58 00 00       	call   80105d90 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 58 00 00       	call   80105d90 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 41 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 41 00 00       	call   80104690 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 73 10 80       	push   $0x80107365
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 73 10 80 	movzbl -0x7fef8c70(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 28 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 ac 3e 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 a4 3f 00 00       	call   80104640 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 fb 10 00 00       	call   801017a0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 73 10 80       	mov    $0x80107378,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 4e 3d 00 00       	call   80104510 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 13 3e 00 00       	call   80104640 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 73 10 80       	push   $0x8010737f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 94 3c 00 00       	call   80104510 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 6c 3c 00 00       	call   80104640 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 1c 38 00 00       	jmp    80104220 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 0b 37 00 00       	call   80104130 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 73 10 80       	push   $0x80107388
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 b7 39 00 00       	call   80104400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 fe 19 00 00       	call   80102470 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 1b 2f 00 00       	call   801039b0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 d0 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 c5 15 00 00       	call   80102070 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 6d 02 00 00    	je     80100d23 <exec+0x2a3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 df 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 ce 0f 00 00       	call   80101aa0 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 5d 0f 00 00       	call   80101a40 <iunlockput>
    end_op();
80100ae3:	e8 f8 22 00 00       	call   80102de0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 3f 64 00 00       	call   80106f50 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 d9 02 00 00    	je     80100e08 <exec+0x388>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 a8 61 00 00       	call   80106d20 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 a2 60 00 00       	call   80106c50 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 ca 0e 00 00       	call   80101aa0 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 e0 62 00 00       	call   80106ed0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 1f 0e 00 00       	call   80101a40 <iunlockput>
  end_op();
80100c21:	e8 ba 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 60 00 00       	call   80106d20 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 c4 00 00 00    	je     80100d08 <exec+0x288>
  clearpteu(pgdir, (char*)(sz - PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 f0 ff ff    	lea    -0x1000(%eax),%eax
80100c4d:	50                   	push   %eax
80100c4e:	57                   	push   %edi
80100c4f:	e8 9c 63 00 00       	call   80106ff0 <clearpteu>
  if((allocuvm(pgdir, sp - PGSIZE, sp)) == 0)
80100c54:	83 c4 0c             	add    $0xc,%esp
80100c57:	68 fc ff ff 7f       	push   $0x7ffffffc
80100c5c:	68 fc ef ff 7f       	push   $0x7fffeffc
80100c61:	57                   	push   %edi
80100c62:	e8 b9 60 00 00       	call   80106d20 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	85 c0                	test   %eax,%eax
80100c6c:	0f 84 96 00 00 00    	je     80100d08 <exec+0x288>
  curproc->numStackPages = 1; // says we created a page for the stack
80100c72:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  sp = STACKBASE; // make stack pointer point to just below the KERNBASE to start
80100c78:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	31 ff                	xor    %edi,%edi
80100c7f:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  curproc->numStackPages = 1; // says we created a page for the stack
80100c85:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  for(argc = 0; argv[argc]; argc++) {
80100c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8f:	8b 00                	mov    (%eax),%eax
80100c91:	85 c0                	test   %eax,%eax
80100c93:	0f 84 af 00 00 00    	je     80100d48 <exec+0x2c8>
80100c99:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c9f:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ca5:	eb 28                	jmp    80100ccf <exec+0x24f>
80100ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cae:	66 90                	xchg   %ax,%ax
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 78                	je     80100d42 <exec+0x2c2>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x288>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 b8 3b 00 00       	call   80104890 <strlen>
80100cd8:	f7 d0                	not    %eax
80100cda:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdc:	58                   	pop    %eax
80100cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ce6:	e8 a5 3b 00 00       	call   80104890 <strlen>
80100ceb:	83 c0 01             	add    $0x1,%eax
80100cee:	50                   	push   %eax
80100cef:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cf5:	53                   	push   %ebx
80100cf6:	56                   	push   %esi
80100cf7:	e8 04 65 00 00       	call   80107200 <copyout>
80100cfc:	83 c4 20             	add    $0x20,%esp
80100cff:	85 c0                	test   %eax,%eax
80100d01:	79 ad                	jns    80100cb0 <exec+0x230>
80100d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d07:	90                   	nop
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d11:	e8 ba 61 00 00       	call   80106ed0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 cd fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100d23:	e8 b8 20 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100d28:	83 ec 0c             	sub    $0xc,%esp
80100d2b:	68 a1 73 10 80       	push   $0x801073a1
80100d30:	e8 7b f9 ff ff       	call   801006b0 <cprintf>
    return -1;
80100d35:	83 c4 10             	add    $0x10,%esp
80100d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d3d:	e9 ae fd ff ff       	jmp    80100af0 <exec+0x70>
80100d42:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d48:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d4f:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d51:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d58:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5c:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d5e:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d61:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d67:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d69:	50                   	push   %eax
80100d6a:	52                   	push   %edx
80100d6b:	53                   	push   %ebx
80100d6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d72:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d79:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7c:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d82:	e8 79 64 00 00       	call   80107200 <copyout>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	85 c0                	test   %eax,%eax
80100d8c:	0f 88 76 ff ff ff    	js     80100d08 <exec+0x288>
  for(last=s=path; *s; s++)
80100d92:	8b 45 08             	mov    0x8(%ebp),%eax
80100d95:	8b 55 08             	mov    0x8(%ebp),%edx
80100d98:	0f b6 00             	movzbl (%eax),%eax
80100d9b:	84 c0                	test   %al,%al
80100d9d:	74 18                	je     80100db7 <exec+0x337>
80100d9f:	89 d1                	mov    %edx,%ecx
80100da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(*s == '/')
80100da8:	83 c1 01             	add    $0x1,%ecx
80100dab:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100dad:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100db0:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100db3:	84 c0                	test   %al,%al
80100db5:	75 f1                	jne    80100da8 <exec+0x328>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100db7:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100dbd:	83 ec 04             	sub    $0x4,%esp
80100dc0:	6a 10                	push   $0x10
80100dc2:	8d 47 6c             	lea    0x6c(%edi),%eax
80100dc5:	52                   	push   %edx
80100dc6:	50                   	push   %eax
80100dc7:	e8 84 3a 00 00       	call   80104850 <safestrcpy>
  curproc->pgdir = pgdir;
80100dcc:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100dd2:	89 f9                	mov    %edi,%ecx
80100dd4:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100dd7:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100dda:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100ddc:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100ddf:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100de5:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100de8:	8b 41 18             	mov    0x18(%ecx),%eax
80100deb:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dee:	89 0c 24             	mov    %ecx,(%esp)
80100df1:	e8 ca 5c 00 00       	call   80106ac0 <switchuvm>
  freevm(oldpgdir);
80100df6:	89 3c 24             	mov    %edi,(%esp)
80100df9:	e8 d2 60 00 00       	call   80106ed0 <freevm>
  return 0;
80100dfe:	83 c4 10             	add    $0x10,%esp
80100e01:	31 c0                	xor    %eax,%eax
80100e03:	e9 e8 fc ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	be 00 10 00 00       	mov    $0x1000,%esi
80100e0f:	e9 04 fe ff ff       	jmp    80100c18 <exec+0x198>
80100e14:	66 90                	xchg   %ax,%ax
80100e16:	66 90                	xchg   %ax,%ax
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	f3 0f 1e fb          	endbr32 
80100e24:	55                   	push   %ebp
80100e25:	89 e5                	mov    %esp,%ebp
80100e27:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e2a:	68 ad 73 10 80       	push   $0x801073ad
80100e2f:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e34:	e8 c7 35 00 00       	call   80104400 <initlock>
}
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	c9                   	leave  
80100e3d:	c3                   	ret    
80100e3e:	66 90                	xchg   %ax,%ax

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	f3 0f 1e fb          	endbr32 
80100e44:	55                   	push   %ebp
80100e45:	89 e5                	mov    %esp,%ebp
80100e47:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e48:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e4d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e50:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e55:	e8 b6 36 00 00       	call   80104510 <acquire>
80100e5a:	83 c4 10             	add    $0x10,%esp
80100e5d:	eb 0c                	jmp    80100e6b <filealloc+0x2b>
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e81:	e8 ba 37 00 00       	call   80104640 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9a:	e8 a1 37 00 00       	call   80104640 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	f3 0f 1e fb          	endbr32 
80100eb4:	55                   	push   %ebp
80100eb5:	89 e5                	mov    %esp,%ebp
80100eb7:	53                   	push   %ebx
80100eb8:	83 ec 10             	sub    $0x10,%esp
80100ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ebe:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ec3:	e8 48 36 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100ec8:	8b 43 04             	mov    0x4(%ebx),%eax
80100ecb:	83 c4 10             	add    $0x10,%esp
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	7e 1a                	jle    80100eec <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ed2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100edb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee0:	e8 5b 37 00 00       	call   80104640 <release>
  return f;
}
80100ee5:	89 d8                	mov    %ebx,%eax
80100ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eea:	c9                   	leave  
80100eeb:	c3                   	ret    
    panic("filedup");
80100eec:	83 ec 0c             	sub    $0xc,%esp
80100eef:	68 b4 73 10 80       	push   $0x801073b4
80100ef4:	e8 97 f4 ff ff       	call   80100390 <panic>
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	f3 0f 1e fb          	endbr32 
80100f04:	55                   	push   %ebp
80100f05:	89 e5                	mov    %esp,%ebp
80100f07:	57                   	push   %edi
80100f08:	56                   	push   %esi
80100f09:	53                   	push   %ebx
80100f0a:	83 ec 28             	sub    $0x28,%esp
80100f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100f15:	e8 f6 35 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100f1a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f1d:	83 c4 10             	add    $0x10,%esp
80100f20:	85 d2                	test   %edx,%edx
80100f22:	0f 8e a1 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f28:	83 ea 01             	sub    $0x1,%edx
80100f2b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2e:	75 40                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f30:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f34:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f37:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f39:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f42:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f45:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f48:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f50:	e8 eb 36 00 00       	call   80104640 <release>

  if(ff.type == FD_PIPE)
80100f55:	83 c4 10             	add    $0x10,%esp
80100f58:	83 ff 01             	cmp    $0x1,%edi
80100f5b:	74 53                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f5d:	83 ff 02             	cmp    $0x2,%edi
80100f60:	74 26                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f65:	5b                   	pop    %ebx
80100f66:	5e                   	pop    %esi
80100f67:	5f                   	pop    %edi
80100f68:	5d                   	pop    %ebp
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 bd 36 00 00       	jmp    80104640 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	pushl  -0x20(%ebp)
80100f93:	e8 38 09 00 00       	call   801018d0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 1e 00 00       	jmp    80102de0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 92 25 00 00       	call   80103550 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 bc 73 10 80       	push   $0x801073bc
80100fd1:	e8 ba f3 ff ff       	call   80100390 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	f3 0f 1e fb          	endbr32 
80100fe4:	55                   	push   %ebp
80100fe5:	89 e5                	mov    %esp,%ebp
80100fe7:	53                   	push   %ebx
80100fe8:	83 ec 04             	sub    $0x4,%esp
80100feb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fee:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ff1:	75 2d                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100ff3:	83 ec 0c             	sub    $0xc,%esp
80100ff6:	ff 73 10             	pushl  0x10(%ebx)
80100ff9:	e8 a2 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
80100ffe:	58                   	pop    %eax
80100fff:	5a                   	pop    %edx
80101000:	ff 75 0c             	pushl  0xc(%ebp)
80101003:	ff 73 10             	pushl  0x10(%ebx)
80101006:	e8 65 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
8010100b:	59                   	pop    %ecx
8010100c:	ff 73 10             	pushl  0x10(%ebx)
8010100f:	e8 6c 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101017:	83 c4 10             	add    $0x10,%esp
8010101a:	31 c0                	xor    %eax,%eax
}
8010101c:	c9                   	leave  
8010101d:	c3                   	ret    
8010101e:	66 90                	xchg   %ax,%ax
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	f3 0f 1e fb          	endbr32 
80101034:	55                   	push   %ebp
80101035:	89 e5                	mov    %esp,%ebp
80101037:	57                   	push   %edi
80101038:	56                   	push   %esi
80101039:	53                   	push   %ebx
8010103a:	83 ec 0c             	sub    $0xc,%esp
8010103d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101040:	8b 75 0c             	mov    0xc(%ebp),%esi
80101043:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101046:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010104a:	74 64                	je     801010b0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010104c:	8b 03                	mov    (%ebx),%eax
8010104e:	83 f8 01             	cmp    $0x1,%eax
80101051:	74 45                	je     80101098 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101053:	83 f8 02             	cmp    $0x2,%eax
80101056:	75 5f                	jne    801010b7 <fileread+0x87>
    ilock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 3d 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101063:	57                   	push   %edi
80101064:	ff 73 14             	pushl  0x14(%ebx)
80101067:	56                   	push   %esi
80101068:	ff 73 10             	pushl  0x10(%ebx)
8010106b:	e8 30 0a 00 00       	call   80101aa0 <readi>
80101070:	83 c4 20             	add    $0x20,%esp
80101073:	89 c6                	mov    %eax,%esi
80101075:	85 c0                	test   %eax,%eax
80101077:	7e 03                	jle    8010107c <fileread+0x4c>
      f->off += r;
80101079:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	ff 73 10             	pushl  0x10(%ebx)
80101082:	e8 f9 07 00 00       	call   80101880 <iunlock>
    return r;
80101087:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010108a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108d:	89 f0                	mov    %esi,%eax
8010108f:	5b                   	pop    %ebx
80101090:	5e                   	pop    %esi
80101091:	5f                   	pop    %edi
80101092:	5d                   	pop    %ebp
80101093:	c3                   	ret    
80101094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101098:	8b 43 0c             	mov    0xc(%ebx),%eax
8010109b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010a5:	e9 46 26 00 00       	jmp    801036f0 <piperead>
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010b5:	eb d3                	jmp    8010108a <fileread+0x5a>
  panic("fileread");
801010b7:	83 ec 0c             	sub    $0xc,%esp
801010ba:	68 c6 73 10 80       	push   $0x801073c6
801010bf:	e8 cc f2 ff ff       	call   80100390 <panic>
801010c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	f3 0f 1e fb          	endbr32 
801010d4:	55                   	push   %ebp
801010d5:	89 e5                	mov    %esp,%ebp
801010d7:	57                   	push   %edi
801010d8:	56                   	push   %esi
801010d9:	53                   	push   %ebx
801010da:	83 ec 1c             	sub    $0x1c,%esp
801010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801010e0:	8b 75 08             	mov    0x8(%ebp),%esi
801010e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010f0:	0f 84 c1 00 00 00    	je     801011b7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010f6:	8b 06                	mov    (%esi),%eax
801010f8:	83 f8 01             	cmp    $0x1,%eax
801010fb:	0f 84 c3 00 00 00    	je     801011c4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101101:	83 f8 02             	cmp    $0x2,%eax
80101104:	0f 85 cc 00 00 00    	jne    801011d6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010110a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010110d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010110f:	85 c0                	test   %eax,%eax
80101111:	7f 34                	jg     80101147 <filewrite+0x77>
80101113:	e9 98 00 00 00       	jmp    801011b0 <filewrite+0xe0>
80101118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101120:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101123:	83 ec 0c             	sub    $0xc,%esp
80101126:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101129:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010112c:	e8 4f 07 00 00       	call   80101880 <iunlock>
      end_op();
80101131:	e8 aa 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101136:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	39 c3                	cmp    %eax,%ebx
8010113e:	75 60                	jne    801011a0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101140:	01 df                	add    %ebx,%edi
    while(i < n){
80101142:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101145:	7e 69                	jle    801011b0 <filewrite+0xe0>
      int n1 = n - i;
80101147:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010114a:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010114f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101151:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101157:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010115a:	e8 11 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 76 10             	pushl  0x10(%esi)
80101165:	e8 36 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010116a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010116d:	53                   	push   %ebx
8010116e:	ff 76 14             	pushl  0x14(%esi)
80101171:	01 f8                	add    %edi,%eax
80101173:	50                   	push   %eax
80101174:	ff 76 10             	pushl  0x10(%esi)
80101177:	e8 24 0a 00 00       	call   80101ba0 <writei>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	85 c0                	test   %eax,%eax
80101181:	7f 9d                	jg     80101120 <filewrite+0x50>
      iunlock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 76 10             	pushl  0x10(%esi)
80101189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010118c:	e8 ef 06 00 00       	call   80101880 <iunlock>
      end_op();
80101191:	e8 4a 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
80101196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101199:	83 c4 10             	add    $0x10,%esp
8010119c:	85 c0                	test   %eax,%eax
8010119e:	75 17                	jne    801011b7 <filewrite+0xe7>
        panic("short filewrite");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 cf 73 10 80       	push   $0x801073cf
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011b0:	89 f8                	mov    %edi,%eax
801011b2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011b5:	74 05                	je     801011bc <filewrite+0xec>
801011b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bf:	5b                   	pop    %ebx
801011c0:	5e                   	pop    %esi
801011c1:	5f                   	pop    %edi
801011c2:	5d                   	pop    %ebp
801011c3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011c4:	8b 46 0c             	mov    0xc(%esi),%eax
801011c7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cd:	5b                   	pop    %ebx
801011ce:	5e                   	pop    %esi
801011cf:	5f                   	pop    %edi
801011d0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011d1:	e9 1a 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011d6:	83 ec 0c             	sub    $0xc,%esp
801011d9:	68 d5 73 10 80       	push   $0x801073d5
801011de:	e8 ad f1 ff ff       	call   80100390 <panic>
801011e3:	66 90                	xchg   %ax,%ax
801011e5:	66 90                	xchg   %ax,%ax
801011e7:	66 90                	xchg   %ax,%ax
801011e9:	66 90                	xchg   %ax,%ax
801011eb:	66 90                	xchg   %ax,%ax
801011ed:	66 90                	xchg   %ax,%ax
801011ef:	90                   	nop

801011f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011f9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101202:	85 c9                	test   %ecx,%ecx
80101204:	0f 84 87 00 00 00    	je     80101291 <balloc+0xa1>
8010120a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101211:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101214:	83 ec 08             	sub    $0x8,%esp
80101217:	89 f0                	mov    %esi,%eax
80101219:	c1 f8 0c             	sar    $0xc,%eax
8010121c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101222:	50                   	push   %eax
80101223:	ff 75 d8             	pushl  -0x28(%ebp)
80101226:	e8 a5 ee ff ff       	call   801000d0 <bread>
8010122b:	83 c4 10             	add    $0x10,%esp
8010122e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101231:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101236:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101239:	31 c0                	xor    %eax,%eax
8010123b:	eb 2f                	jmp    8010126c <balloc+0x7c>
8010123d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101240:	89 c1                	mov    %eax,%ecx
80101242:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010124a:	83 e1 07             	and    $0x7,%ecx
8010124d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010124f:	89 c1                	mov    %eax,%ecx
80101251:	c1 f9 03             	sar    $0x3,%ecx
80101254:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101259:	89 fa                	mov    %edi,%edx
8010125b:	85 df                	test   %ebx,%edi
8010125d:	74 41                	je     801012a0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010125f:	83 c0 01             	add    $0x1,%eax
80101262:	83 c6 01             	add    $0x1,%esi
80101265:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010126a:	74 05                	je     80101271 <balloc+0x81>
8010126c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010126f:	77 cf                	ja     80101240 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101271:	83 ec 0c             	sub    $0xc,%esp
80101274:	ff 75 e4             	pushl  -0x1c(%ebp)
80101277:	e8 74 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010127c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101289:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010128f:	77 80                	ja     80101211 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101291:	83 ec 0c             	sub    $0xc,%esp
80101294:	68 df 73 10 80       	push   $0x801073df
80101299:	e8 f2 f0 ff ff       	call   80100390 <panic>
8010129e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012a3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012a6:	09 da                	or     %ebx,%edx
801012a8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ac:	57                   	push   %edi
801012ad:	e8 9e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
801012b2:	89 3c 24             	mov    %edi,(%esp)
801012b5:	e8 36 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012ba:	58                   	pop    %eax
801012bb:	5a                   	pop    %edx
801012bc:	56                   	push   %esi
801012bd:	ff 75 d8             	pushl  -0x28(%ebp)
801012c0:	e8 0b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801012cd:	68 00 02 00 00       	push   $0x200
801012d2:	6a 00                	push   $0x0
801012d4:	50                   	push   %eax
801012d5:	e8 b6 33 00 00       	call   80104690 <memset>
  log_write(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 6e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
801012e2:	89 1c 24             	mov    %ebx,(%esp)
801012e5:	e8 06 ef ff ff       	call   801001f0 <brelse>
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012ff:	90                   	nop

80101300 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	89 c7                	mov    %eax,%edi
80101306:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101307:	31 f6                	xor    %esi,%esi
{
80101309:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010130f:	83 ec 28             	sub    $0x28,%esp
80101312:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101315:	68 e0 09 11 80       	push   $0x801109e0
8010131a:	e8 f1 31 00 00       	call   80104510 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101322:	83 c4 10             	add    $0x10,%esp
80101325:	eb 1b                	jmp    80101342 <iget+0x42>
80101327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101330:	39 3b                	cmp    %edi,(%ebx)
80101332:	74 6c                	je     801013a0 <iget+0xa0>
80101334:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101340:	73 26                	jae    80101368 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101342:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101345:	85 c9                	test   %ecx,%ecx
80101347:	7f e7                	jg     80101330 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101349:	85 f6                	test   %esi,%esi
8010134b:	75 e7                	jne    80101334 <iget+0x34>
8010134d:	89 d8                	mov    %ebx,%eax
8010134f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101355:	85 c9                	test   %ecx,%ecx
80101357:	75 6e                	jne    801013c7 <iget+0xc7>
80101359:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101361:	72 df                	jb     80101342 <iget+0x42>
80101363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101367:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101368:	85 f6                	test   %esi,%esi
8010136a:	74 73                	je     801013df <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010136c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010136f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101371:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101374:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010137b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101382:	68 e0 09 11 80       	push   $0x801109e0
80101387:	e8 b4 32 00 00       	call   80104640 <release>

  return ip;
8010138c:	83 c4 10             	add    $0x10,%esp
}
8010138f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101392:	89 f0                	mov    %esi,%eax
80101394:	5b                   	pop    %ebx
80101395:	5e                   	pop    %esi
80101396:	5f                   	pop    %edi
80101397:	5d                   	pop    %ebp
80101398:	c3                   	ret    
80101399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013a3:	75 8f                	jne    80101334 <iget+0x34>
      release(&icache.lock);
801013a5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013a8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013ab:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ad:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801013b2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013b5:	e8 86 32 00 00       	call   80104640 <release>
      return ip;
801013ba:	83 c4 10             	add    $0x10,%esp
}
801013bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c0:	89 f0                	mov    %esi,%eax
801013c2:	5b                   	pop    %ebx
801013c3:	5e                   	pop    %esi
801013c4:	5f                   	pop    %edi
801013c5:	5d                   	pop    %ebp
801013c6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c7:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013cd:	73 10                	jae    801013df <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013cf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013d2:	85 c9                	test   %ecx,%ecx
801013d4:	0f 8f 56 ff ff ff    	jg     80101330 <iget+0x30>
801013da:	e9 6e ff ff ff       	jmp    8010134d <iget+0x4d>
    panic("iget: no inodes");
801013df:	83 ec 0c             	sub    $0xc,%esp
801013e2:	68 f5 73 10 80       	push   $0x801073f5
801013e7:	e8 a4 ef ff ff       	call   80100390 <panic>
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	56                   	push   %esi
801013f5:	89 c6                	mov    %eax,%esi
801013f7:	53                   	push   %ebx
801013f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013fb:	83 fa 0b             	cmp    $0xb,%edx
801013fe:	0f 86 84 00 00 00    	jbe    80101488 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101404:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101407:	83 fb 7f             	cmp    $0x7f,%ebx
8010140a:	0f 87 98 00 00 00    	ja     801014a8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101410:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101416:	8b 16                	mov    (%esi),%edx
80101418:	85 c0                	test   %eax,%eax
8010141a:	74 54                	je     80101470 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	50                   	push   %eax
80101420:	52                   	push   %edx
80101421:	e8 aa ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010142d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010142f:	8b 1a                	mov    (%edx),%ebx
80101431:	85 db                	test   %ebx,%ebx
80101433:	74 1b                	je     80101450 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	57                   	push   %edi
80101439:	e8 b2 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010143e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101444:	89 d8                	mov    %ebx,%eax
80101446:	5b                   	pop    %ebx
80101447:	5e                   	pop    %esi
80101448:	5f                   	pop    %edi
80101449:	5d                   	pop    %ebp
8010144a:	c3                   	ret    
8010144b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010144f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101450:	8b 06                	mov    (%esi),%eax
80101452:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101455:	e8 96 fd ff ff       	call   801011f0 <balloc>
8010145a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010145d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101460:	89 c3                	mov    %eax,%ebx
80101462:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101464:	57                   	push   %edi
80101465:	e8 e6 1a 00 00       	call   80102f50 <log_write>
8010146a:	83 c4 10             	add    $0x10,%esp
8010146d:	eb c6                	jmp    80101435 <bmap+0x45>
8010146f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101470:	89 d0                	mov    %edx,%eax
80101472:	e8 79 fd ff ff       	call   801011f0 <balloc>
80101477:	8b 16                	mov    (%esi),%edx
80101479:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010147f:	eb 9b                	jmp    8010141c <bmap+0x2c>
80101481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101488:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010148b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010148e:	85 db                	test   %ebx,%ebx
80101490:	75 af                	jne    80101441 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101492:	8b 00                	mov    (%eax),%eax
80101494:	e8 57 fd ff ff       	call   801011f0 <balloc>
80101499:	89 47 5c             	mov    %eax,0x5c(%edi)
8010149c:	89 c3                	mov    %eax,%ebx
}
8010149e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a1:	89 d8                	mov    %ebx,%eax
801014a3:	5b                   	pop    %ebx
801014a4:	5e                   	pop    %esi
801014a5:	5f                   	pop    %edi
801014a6:	5d                   	pop    %ebp
801014a7:	c3                   	ret    
  panic("bmap: out of range");
801014a8:	83 ec 0c             	sub    $0xc,%esp
801014ab:	68 05 74 10 80       	push   $0x80107405
801014b0:	e8 db ee ff ff       	call   80100390 <panic>
801014b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014c0 <readsb>:
{
801014c0:	f3 0f 1e fb          	endbr32 
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	56                   	push   %esi
801014c8:	53                   	push   %ebx
801014c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014cc:	83 ec 08             	sub    $0x8,%esp
801014cf:	6a 01                	push   $0x1
801014d1:	ff 75 08             	pushl  0x8(%ebp)
801014d4:	e8 f7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801014d9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801014dc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014de:	8d 40 5c             	lea    0x5c(%eax),%eax
801014e1:	6a 1c                	push   $0x1c
801014e3:	50                   	push   %eax
801014e4:	56                   	push   %esi
801014e5:	e8 46 32 00 00       	call   80104730 <memmove>
  brelse(bp);
801014ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014ed:	83 c4 10             	add    $0x10,%esp
}
801014f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5d                   	pop    %ebp
  brelse(bp);
801014f6:	e9 f5 ec ff ff       	jmp    801001f0 <brelse>
801014fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014ff:	90                   	nop

80101500 <bfree>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	56                   	push   %esi
80101504:	89 c6                	mov    %eax,%esi
80101506:	53                   	push   %ebx
80101507:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101509:	83 ec 08             	sub    $0x8,%esp
8010150c:	68 c0 09 11 80       	push   $0x801109c0
80101511:	50                   	push   %eax
80101512:	e8 a9 ff ff ff       	call   801014c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101517:	58                   	pop    %eax
80101518:	89 d8                	mov    %ebx,%eax
8010151a:	5a                   	pop    %edx
8010151b:	c1 e8 0c             	shr    $0xc,%eax
8010151e:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101524:	50                   	push   %eax
80101525:	56                   	push   %esi
80101526:	e8 a5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010152b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010152d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101530:	ba 01 00 00 00       	mov    $0x1,%edx
80101535:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101538:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010153e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101541:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101543:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101548:	85 d1                	test   %edx,%ecx
8010154a:	74 25                	je     80101571 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010154c:	f7 d2                	not    %edx
  log_write(bp);
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101553:	21 ca                	and    %ecx,%edx
80101555:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101559:	50                   	push   %eax
8010155a:	e8 f1 19 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010155f:	89 34 24             	mov    %esi,(%esp)
80101562:	e8 89 ec ff ff       	call   801001f0 <brelse>
}
80101567:	83 c4 10             	add    $0x10,%esp
8010156a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156d:	5b                   	pop    %ebx
8010156e:	5e                   	pop    %esi
8010156f:	5d                   	pop    %ebp
80101570:	c3                   	ret    
    panic("freeing free block");
80101571:	83 ec 0c             	sub    $0xc,%esp
80101574:	68 18 74 10 80       	push   $0x80107418
80101579:	e8 12 ee ff ff       	call   80100390 <panic>
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	f3 0f 1e fb          	endbr32 
80101584:	55                   	push   %ebp
80101585:	89 e5                	mov    %esp,%ebp
80101587:	53                   	push   %ebx
80101588:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010158d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101590:	68 2b 74 10 80       	push   $0x8010742b
80101595:	68 e0 09 11 80       	push   $0x801109e0
8010159a:	e8 61 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159f:	83 c4 10             	add    $0x10,%esp
801015a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	68 32 74 10 80       	push   $0x80107432
801015b0:	53                   	push   %ebx
801015b1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015b7:	e8 34 2d 00 00       	call   801042f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015bc:	83 c4 10             	add    $0x10,%esp
801015bf:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801015c5:	75 e1                	jne    801015a8 <iinit+0x28>
  readsb(dev, &sb);
801015c7:	83 ec 08             	sub    $0x8,%esp
801015ca:	68 c0 09 11 80       	push   $0x801109c0
801015cf:	ff 75 08             	pushl  0x8(%ebp)
801015d2:	e8 e9 fe ff ff       	call   801014c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015dd:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015e3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015e9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015ef:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015f5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015fb:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101601:	68 98 74 10 80       	push   $0x80107498
80101606:	e8 a5 f0 ff ff       	call   801006b0 <cprintf>
}
8010160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010160e:	83 c4 30             	add    $0x30,%esp
80101611:	c9                   	leave  
80101612:	c3                   	ret    
80101613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101620 <ialloc>:
{
80101620:	f3 0f 1e fb          	endbr32 
80101624:	55                   	push   %ebp
80101625:	89 e5                	mov    %esp,%ebp
80101627:	57                   	push   %edi
80101628:	56                   	push   %esi
80101629:	53                   	push   %ebx
8010162a:	83 ec 1c             	sub    $0x1c,%esp
8010162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101630:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101637:	8b 75 08             	mov    0x8(%ebp),%esi
8010163a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010163d:	0f 86 8d 00 00 00    	jbe    801016d0 <ialloc+0xb0>
80101643:	bf 01 00 00 00       	mov    $0x1,%edi
80101648:	eb 1d                	jmp    80101667 <ialloc+0x47>
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 ed 2f 00 00       	call   80104690 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 30 fc ff ff       	jmp    80101300 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 38 74 10 80       	push   $0x80107438
801016d8:	e8 b3 ec ff ff       	call   80100390 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	f3 0f 1e fb          	endbr32 
801016e4:	55                   	push   %ebp
801016e5:	89 e5                	mov    %esp,%ebp
801016e7:	56                   	push   %esi
801016e8:	53                   	push   %ebx
801016e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ec:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ef:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f2:	83 ec 08             	sub    $0x8,%esp
801016f5:	c1 e8 03             	shr    $0x3,%eax
801016f8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016fe:	50                   	push   %eax
801016ff:	ff 73 a4             	pushl  -0x5c(%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101707:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101710:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101713:	83 e0 07             	and    $0x7,%eax
80101716:	c1 e0 06             	shl    $0x6,%eax
80101719:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010171d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101720:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101724:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101727:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010172b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101733:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101737:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010173b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	53                   	push   %ebx
80101744:	50                   	push   %eax
80101745:	e8 e6 2f 00 00       	call   80104730 <memmove>
  log_write(bp);
8010174a:	89 34 24             	mov    %esi,(%esp)
8010174d:	e8 fe 17 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101752:	89 75 08             	mov    %esi,0x8(%ebp)
80101755:	83 c4 10             	add    $0x10,%esp
}
80101758:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175b:	5b                   	pop    %ebx
8010175c:	5e                   	pop    %esi
8010175d:	5d                   	pop    %ebp
  brelse(bp);
8010175e:	e9 8d ea ff ff       	jmp    801001f0 <brelse>
80101763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101770 <idup>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	53                   	push   %ebx
80101778:	83 ec 10             	sub    $0x10,%esp
8010177b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177e:	68 e0 09 11 80       	push   $0x801109e0
80101783:	e8 88 2d 00 00       	call   80104510 <acquire>
  ip->ref++;
80101788:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010178c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101793:	e8 a8 2e 00 00       	call   80104640 <release>
}
80101798:	89 d8                	mov    %ebx,%eax
8010179a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179d:	c9                   	leave  
8010179e:	c3                   	ret    
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	f3 0f 1e fb          	endbr32 
801017a4:	55                   	push   %ebp
801017a5:	89 e5                	mov    %esp,%ebp
801017a7:	56                   	push   %esi
801017a8:	53                   	push   %ebx
801017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017ac:	85 db                	test   %ebx,%ebx
801017ae:	0f 84 b3 00 00 00    	je     80101867 <ilock+0xc7>
801017b4:	8b 53 08             	mov    0x8(%ebx),%edx
801017b7:	85 d2                	test   %edx,%edx
801017b9:	0f 8e a8 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bf:	83 ec 0c             	sub    $0xc,%esp
801017c2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c5:	50                   	push   %eax
801017c6:	e8 65 2b 00 00       	call   80104330 <acquiresleep>
  if(ip->valid == 0){
801017cb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	85 c0                	test   %eax,%eax
801017d3:	74 0b                	je     801017e0 <ilock+0x40>
}
801017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d8:	5b                   	pop    %ebx
801017d9:	5e                   	pop    %esi
801017da:	5d                   	pop    %ebp
801017db:	c3                   	ret    
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	pushl  (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 f3 2e 00 00       	call   80104730 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 7b ff ff ff    	jne    801017d5 <ilock+0x35>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 50 74 10 80       	push   $0x80107450
80101862:	e8 29 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 4a 74 10 80       	push   $0x8010744a
8010186f:	e8 1c eb ff ff       	call   80100390 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	f3 0f 1e fb          	endbr32 
80101884:	55                   	push   %ebp
80101885:	89 e5                	mov    %esp,%ebp
80101887:	56                   	push   %esi
80101888:	53                   	push   %ebx
80101889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010188c:	85 db                	test   %ebx,%ebx
8010188e:	74 28                	je     801018b8 <iunlock+0x38>
80101890:	83 ec 0c             	sub    $0xc,%esp
80101893:	8d 73 0c             	lea    0xc(%ebx),%esi
80101896:	56                   	push   %esi
80101897:	e8 34 2b 00 00       	call   801043d0 <holdingsleep>
8010189c:	83 c4 10             	add    $0x10,%esp
8010189f:	85 c0                	test   %eax,%eax
801018a1:	74 15                	je     801018b8 <iunlock+0x38>
801018a3:	8b 43 08             	mov    0x8(%ebx),%eax
801018a6:	85 c0                	test   %eax,%eax
801018a8:	7e 0e                	jle    801018b8 <iunlock+0x38>
  releasesleep(&ip->lock);
801018aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018b3:	e9 d8 2a 00 00       	jmp    80104390 <releasesleep>
    panic("iunlock");
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 5f 74 10 80       	push   $0x8010745f
801018c0:	e8 cb ea ff ff       	call   80100390 <panic>
801018c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	57                   	push   %edi
801018d8:	56                   	push   %esi
801018d9:	53                   	push   %ebx
801018da:	83 ec 28             	sub    $0x28,%esp
801018dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018e0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018e3:	57                   	push   %edi
801018e4:	e8 47 2a 00 00       	call   80104330 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	85 d2                	test   %edx,%edx
801018f1:	74 07                	je     801018fa <iput+0x2a>
801018f3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f8:	74 36                	je     80101930 <iput+0x60>
  releasesleep(&ip->lock);
801018fa:	83 ec 0c             	sub    $0xc,%esp
801018fd:	57                   	push   %edi
801018fe:	e8 8d 2a 00 00       	call   80104390 <releasesleep>
  acquire(&icache.lock);
80101903:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010190a:	e8 01 2c 00 00       	call   80104510 <acquire>
  ip->ref--;
8010190f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
8010191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101920:	5b                   	pop    %ebx
80101921:	5e                   	pop    %esi
80101922:	5f                   	pop    %edi
80101923:	5d                   	pop    %ebp
  release(&icache.lock);
80101924:	e9 17 2d 00 00       	jmp    80104640 <release>
80101929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 e0 09 11 80       	push   $0x801109e0
80101938:	e8 d3 2b 00 00       	call   80104510 <acquire>
    int r = ip->ref;
8010193d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101940:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101947:	e8 f4 2c 00 00       	call   80104640 <release>
    if(r == 1){
8010194c:	83 c4 10             	add    $0x10,%esp
8010194f:	83 fe 01             	cmp    $0x1,%esi
80101952:	75 a6                	jne    801018fa <iput+0x2a>
80101954:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010195a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010195d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101960:	89 cf                	mov    %ecx,%edi
80101962:	eb 0b                	jmp    8010196f <iput+0x9f>
80101964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 fe                	cmp    %edi,%esi
8010196d:	74 19                	je     80101988 <iput+0xb8>
    if(ip->addrs[i]){
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 84 fb ff ff       	call   80101500 <bfree>
      ip->addrs[i] = 0;
8010197c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101982:	eb e4                	jmp    80101968 <iput+0x98>
80101984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101988:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101991:	85 c0                	test   %eax,%eax
80101993:	75 33                	jne    801019c8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101995:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101998:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010199f:	53                   	push   %ebx
801019a0:	e8 3b fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
801019a5:	31 c0                	xor    %eax,%eax
801019a7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019ab:	89 1c 24             	mov    %ebx,(%esp)
801019ae:	e8 2d fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
801019b3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019ba:	83 c4 10             	add    $0x10,%esp
801019bd:	e9 38 ff ff ff       	jmp    801018fa <iput+0x2a>
801019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019c8:	83 ec 08             	sub    $0x8,%esp
801019cb:	50                   	push   %eax
801019cc:	ff 33                	pushl  (%ebx)
801019ce:	e8 fd e6 ff ff       	call   801000d0 <bread>
801019d3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019d6:	83 c4 10             	add    $0x10,%esp
801019d9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019e2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019e5:	89 cf                	mov    %ecx,%edi
801019e7:	eb 0e                	jmp    801019f7 <iput+0x127>
801019e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019f0:	83 c6 04             	add    $0x4,%esi
801019f3:	39 f7                	cmp    %esi,%edi
801019f5:	74 19                	je     80101a10 <iput+0x140>
      if(a[j])
801019f7:	8b 16                	mov    (%esi),%edx
801019f9:	85 d2                	test   %edx,%edx
801019fb:	74 f3                	je     801019f0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019fd:	8b 03                	mov    (%ebx),%eax
801019ff:	e8 fc fa ff ff       	call   80101500 <bfree>
80101a04:	eb ea                	jmp    801019f0 <iput+0x120>
80101a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a16:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a19:	e8 d2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a1e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a24:	8b 03                	mov    (%ebx),%eax
80101a26:	e8 d5 fa ff ff       	call   80101500 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a2b:	83 c4 10             	add    $0x10,%esp
80101a2e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a35:	00 00 00 
80101a38:	e9 58 ff ff ff       	jmp    80101995 <iput+0xc5>
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi

80101a40 <iunlockput>:
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	53                   	push   %ebx
80101a48:	83 ec 10             	sub    $0x10,%esp
80101a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a4e:	53                   	push   %ebx
80101a4f:	e8 2c fe ff ff       	call   80101880 <iunlock>
  iput(ip);
80101a54:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a57:	83 c4 10             	add    $0x10,%esp
}
80101a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a5d:	c9                   	leave  
  iput(ip);
80101a5e:	e9 6d fe ff ff       	jmp    801018d0 <iput>
80101a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	8b 55 08             	mov    0x8(%ebp),%edx
80101a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a7d:	8b 0a                	mov    (%edx),%ecx
80101a7f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a82:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a85:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a88:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a8c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a93:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a97:	8b 52 58             	mov    0x58(%edx),%edx
80101a9a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a9d:	5d                   	pop    %ebp
80101a9e:	c3                   	ret    
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	f3 0f 1e fb          	endbr32 
80101aa4:	55                   	push   %ebp
80101aa5:	89 e5                	mov    %esp,%ebp
80101aa7:	57                   	push   %edi
80101aa8:	56                   	push   %esi
80101aa9:	53                   	push   %ebx
80101aaa:	83 ec 1c             	sub    $0x1c,%esp
80101aad:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101abc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ac1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac7:	0f 84 a3 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101acd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ad0:	8b 40 58             	mov    0x58(%eax),%eax
80101ad3:	39 c6                	cmp    %eax,%esi
80101ad5:	0f 87 b6 00 00 00    	ja     80101b91 <readi+0xf1>
80101adb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ade:	31 c9                	xor    %ecx,%ecx
80101ae0:	89 da                	mov    %ebx,%edx
80101ae2:	01 f2                	add    %esi,%edx
80101ae4:	0f 92 c1             	setb   %cl
80101ae7:	89 cf                	mov    %ecx,%edi
80101ae9:	0f 82 a2 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aef:	89 c1                	mov    %eax,%ecx
80101af1:	29 f1                	sub    %esi,%ecx
80101af3:	39 d0                	cmp    %edx,%eax
80101af5:	0f 43 cb             	cmovae %ebx,%ecx
80101af8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101afb:	85 c9                	test   %ecx,%ecx
80101afd:	74 63                	je     80101b62 <readi+0xc2>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 e1 f8 ff ff       	call   801013f0 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	pushl  (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b22:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b25:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	89 f0                	mov    %esi,%eax
80101b29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b30:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b35:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b39:	39 d9                	cmp    %ebx,%ecx
80101b3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	pushl  -0x20(%ebp)
80101b47:	e8 e4 2b 00 00       	call   80104730 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	f3 0f 1e fb          	endbr32 
80101ba4:	55                   	push   %ebp
80101ba5:	89 e5                	mov    %esp,%ebp
80101ba7:	57                   	push   %edi
80101ba8:	56                   	push   %esi
80101ba9:	53                   	push   %ebx
80101baa:	83 ec 1c             	sub    $0x1c,%esp
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bb3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bbb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc1:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc7:	0f 84 b3 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bd0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bd3:	0f 82 e3 00 00 00    	jb     80101cbc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bdc:	89 f8                	mov    %edi,%eax
80101bde:	01 f0                	add    %esi,%eax
80101be0:	0f 82 d6 00 00 00    	jb     80101cbc <writei+0x11c>
80101be6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101beb:	0f 87 cb 00 00 00    	ja     80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bf8:	85 ff                	test   %edi,%edi
80101bfa:	74 75                	je     80101c71 <writei+0xd1>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 e1 f7 ff ff       	call   801013f0 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	pushl  (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	39 d9                	cmp    %ebx,%ecx
80101c39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 e8 2a 00 00       	call   80104730 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cda:	6a 0e                	push   $0xe
80101cdc:	ff 75 0c             	pushl  0xc(%ebp)
80101cdf:	ff 75 08             	pushl  0x8(%ebp)
80101ce2:	e8 b9 2a 00 00       	call   801047a0 <strncmp>
}
80101ce7:	c9                   	leave  
80101ce8:	c3                   	ret    
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	f3 0f 1e fb          	endbr32 
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	57                   	push   %edi
80101cf8:	56                   	push   %esi
80101cf9:	53                   	push   %ebx
80101cfa:	83 ec 1c             	sub    $0x1c,%esp
80101cfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d00:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d05:	0f 85 89 00 00 00    	jne    80101d94 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d0b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0e:	31 ff                	xor    %edi,%edi
80101d10:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d13:	85 d2                	test   %edx,%edx
80101d15:	74 42                	je     80101d59 <dirlookup+0x69>
80101d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d20:	6a 10                	push   $0x10
80101d22:	57                   	push   %edi
80101d23:	56                   	push   %esi
80101d24:	53                   	push   %ebx
80101d25:	e8 76 fd ff ff       	call   80101aa0 <readi>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	83 f8 10             	cmp    $0x10,%eax
80101d30:	75 55                	jne    80101d87 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d32:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d37:	74 18                	je     80101d51 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d39:	83 ec 04             	sub    $0x4,%esp
80101d3c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d3f:	6a 0e                	push   $0xe
80101d41:	50                   	push   %eax
80101d42:	ff 75 0c             	pushl  0xc(%ebp)
80101d45:	e8 56 2a 00 00       	call   801047a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	85 c0                	test   %eax,%eax
80101d4f:	74 17                	je     80101d68 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d51:	83 c7 10             	add    $0x10,%edi
80101d54:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d57:	72 c7                	jb     80101d20 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d5c:	31 c0                	xor    %eax,%eax
}
80101d5e:	5b                   	pop    %ebx
80101d5f:	5e                   	pop    %esi
80101d60:	5f                   	pop    %edi
80101d61:	5d                   	pop    %ebp
80101d62:	c3                   	ret    
80101d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d67:	90                   	nop
      if(poff)
80101d68:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6b:	85 c0                	test   %eax,%eax
80101d6d:	74 05                	je     80101d74 <dirlookup+0x84>
        *poff = off;
80101d6f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d72:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d74:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d78:	8b 03                	mov    (%ebx),%eax
80101d7a:	e8 81 f5 ff ff       	call   80101300 <iget>
}
80101d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d82:	5b                   	pop    %ebx
80101d83:	5e                   	pop    %esi
80101d84:	5f                   	pop    %edi
80101d85:	5d                   	pop    %ebp
80101d86:	c3                   	ret    
      panic("dirlookup read");
80101d87:	83 ec 0c             	sub    $0xc,%esp
80101d8a:	68 79 74 10 80       	push   $0x80107479
80101d8f:	e8 fc e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	68 67 74 10 80       	push   $0x80107467
80101d9c:	e8 ef e5 ff ff       	call   80100390 <panic>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 86 01 00 00    	je     80101f50 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 e1 1b 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101dd4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd7:	68 e0 09 11 80       	push   $0x801109e0
80101ddc:	e8 2f 27 00 00       	call   80104510 <acquire>
  ip->ref++;
80101de1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dec:	e8 4f 28 00 00       	call   80104640 <release>
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	eb 0d                	jmp    80101e03 <namex+0x53>
80101df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e00:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e03:	0f b6 07             	movzbl (%edi),%eax
80101e06:	3c 2f                	cmp    $0x2f,%al
80101e08:	74 f6                	je     80101e00 <namex+0x50>
  if(*path == 0)
80101e0a:	84 c0                	test   %al,%al
80101e0c:	0f 84 ee 00 00 00    	je     80101f00 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e12:	0f b6 07             	movzbl (%edi),%eax
80101e15:	84 c0                	test   %al,%al
80101e17:	0f 84 fb 00 00 00    	je     80101f18 <namex+0x168>
80101e1d:	89 fb                	mov    %edi,%ebx
80101e1f:	3c 2f                	cmp    $0x2f,%al
80101e21:	0f 84 f1 00 00 00    	je     80101f18 <namex+0x168>
80101e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e2e:	66 90                	xchg   %ax,%ax
80101e30:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e34:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e37:	3c 2f                	cmp    $0x2f,%al
80101e39:	74 04                	je     80101e3f <namex+0x8f>
80101e3b:	84 c0                	test   %al,%al
80101e3d:	75 f1                	jne    80101e30 <namex+0x80>
  len = path - s;
80101e3f:	89 d8                	mov    %ebx,%eax
80101e41:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e43:	83 f8 0d             	cmp    $0xd,%eax
80101e46:	0f 8e 84 00 00 00    	jle    80101ed0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e4c:	83 ec 04             	sub    $0x4,%esp
80101e4f:	6a 0e                	push   $0xe
80101e51:	57                   	push   %edi
    path++;
80101e52:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e54:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e57:	e8 d4 28 00 00       	call   80104730 <memmove>
80101e5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e5f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e62:	75 0c                	jne    80101e70 <namex+0xc0>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e68:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e6b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e6e:	74 f8                	je     80101e68 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	56                   	push   %esi
80101e74:	e8 27 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e79:	83 c4 10             	add    $0x10,%esp
80101e7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e81:	0f 85 a1 00 00 00    	jne    80101f28 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e8a:	85 d2                	test   %edx,%edx
80101e8c:	74 09                	je     80101e97 <namex+0xe7>
80101e8e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e91:	0f 84 d9 00 00 00    	je     80101f70 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e97:	83 ec 04             	sub    $0x4,%esp
80101e9a:	6a 00                	push   $0x0
80101e9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e9f:	56                   	push   %esi
80101ea0:	e8 4b fe ff ff       	call   80101cf0 <dirlookup>
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	89 c3                	mov    %eax,%ebx
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	74 7a                	je     80101f28 <namex+0x178>
  iunlock(ip);
80101eae:	83 ec 0c             	sub    $0xc,%esp
80101eb1:	56                   	push   %esi
80101eb2:	e8 c9 f9 ff ff       	call   80101880 <iunlock>
  iput(ip);
80101eb7:	89 34 24             	mov    %esi,(%esp)
80101eba:	89 de                	mov    %ebx,%esi
80101ebc:	e8 0f fa ff ff       	call   801018d0 <iput>
80101ec1:	83 c4 10             	add    $0x10,%esp
80101ec4:	e9 3a ff ff ff       	jmp    80101e03 <namex+0x53>
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ed3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ed6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ed9:	83 ec 04             	sub    $0x4,%esp
80101edc:	50                   	push   %eax
80101edd:	57                   	push   %edi
    name[len] = 0;
80101ede:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ee0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ee3:	e8 48 28 00 00       	call   80104730 <memmove>
    name[len] = 0;
80101ee8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	c6 00 00             	movb   $0x0,(%eax)
80101ef1:	e9 69 ff ff ff       	jmp    80101e5f <namex+0xaf>
80101ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 85 00 00 00    	jne    80101f90 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
80101f15:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f1b:	89 fb                	mov    %edi,%ebx
80101f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f20:	31 c0                	xor    %eax,%eax
80101f22:	eb b5                	jmp    80101ed9 <namex+0x129>
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	56                   	push   %esi
80101f2c:	e8 4f f9 ff ff       	call   80101880 <iunlock>
  iput(ip);
80101f31:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f34:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f36:	e8 95 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f3b:	83 c4 10             	add    $0x10,%esp
}
80101f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f41:	89 f0                	mov    %esi,%eax
80101f43:	5b                   	pop    %ebx
80101f44:	5e                   	pop    %esi
80101f45:	5f                   	pop    %edi
80101f46:	5d                   	pop    %ebp
80101f47:	c3                   	ret    
80101f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f50:	ba 01 00 00 00       	mov    $0x1,%edx
80101f55:	b8 01 00 00 00       	mov    $0x1,%eax
80101f5a:	89 df                	mov    %ebx,%edi
80101f5c:	e8 9f f3 ff ff       	call   80101300 <iget>
80101f61:	89 c6                	mov    %eax,%esi
80101f63:	e9 9b fe ff ff       	jmp    80101e03 <namex+0x53>
80101f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6f:	90                   	nop
      iunlock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 07 f9 ff ff       	call   80101880 <iunlock>
      return ip;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
80101f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	56                   	push   %esi
    return 0;
80101f94:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f96:	e8 35 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	e9 68 ff ff ff       	jmp    80101f0b <namex+0x15b>
80101fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fb0 <dirlink>:
{
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	57                   	push   %edi
80101fb8:	56                   	push   %esi
80101fb9:	53                   	push   %ebx
80101fba:	83 ec 20             	sub    $0x20,%esp
80101fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fc0:	6a 00                	push   $0x0
80101fc2:	ff 75 0c             	pushl  0xc(%ebp)
80101fc5:	53                   	push   %ebx
80101fc6:	e8 25 fd ff ff       	call   80101cf0 <dirlookup>
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	85 c0                	test   %eax,%eax
80101fd0:	75 6b                	jne    8010203d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fd2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fd5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fd8:	85 ff                	test   %edi,%edi
80101fda:	74 2d                	je     80102009 <dirlink+0x59>
80101fdc:	31 ff                	xor    %edi,%edi
80101fde:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe1:	eb 0d                	jmp    80101ff0 <dirlink+0x40>
80101fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe7:	90                   	nop
80101fe8:	83 c7 10             	add    $0x10,%edi
80101feb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fee:	73 19                	jae    80102009 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff0:	6a 10                	push   $0x10
80101ff2:	57                   	push   %edi
80101ff3:	56                   	push   %esi
80101ff4:	53                   	push   %ebx
80101ff5:	e8 a6 fa ff ff       	call   80101aa0 <readi>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	83 f8 10             	cmp    $0x10,%eax
80102000:	75 4e                	jne    80102050 <dirlink+0xa0>
    if(de.inum == 0)
80102002:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102007:	75 df                	jne    80101fe8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102009:	83 ec 04             	sub    $0x4,%esp
8010200c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010200f:	6a 0e                	push   $0xe
80102011:	ff 75 0c             	pushl  0xc(%ebp)
80102014:	50                   	push   %eax
80102015:	e8 d6 27 00 00       	call   801047f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010201a:	6a 10                	push   $0x10
  de.inum = inum;
8010201c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010201f:	57                   	push   %edi
80102020:	56                   	push   %esi
80102021:	53                   	push   %ebx
  de.inum = inum;
80102022:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102026:	e8 75 fb ff ff       	call   80101ba0 <writei>
8010202b:	83 c4 20             	add    $0x20,%esp
8010202e:	83 f8 10             	cmp    $0x10,%eax
80102031:	75 2a                	jne    8010205d <dirlink+0xad>
  return 0;
80102033:	31 c0                	xor    %eax,%eax
}
80102035:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102038:	5b                   	pop    %ebx
80102039:	5e                   	pop    %esi
8010203a:	5f                   	pop    %edi
8010203b:	5d                   	pop    %ebp
8010203c:	c3                   	ret    
    iput(ip);
8010203d:	83 ec 0c             	sub    $0xc,%esp
80102040:	50                   	push   %eax
80102041:	e8 8a f8 ff ff       	call   801018d0 <iput>
    return -1;
80102046:	83 c4 10             	add    $0x10,%esp
80102049:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010204e:	eb e5                	jmp    80102035 <dirlink+0x85>
      panic("dirlink read");
80102050:	83 ec 0c             	sub    $0xc,%esp
80102053:	68 88 74 10 80       	push   $0x80107488
80102058:	e8 33 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010205d:	83 ec 0c             	sub    $0xc,%esp
80102060:	68 66 7a 10 80       	push   $0x80107a66
80102065:	e8 26 e3 ff ff       	call   80100390 <panic>
8010206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102070 <namei>:

struct inode*
namei(char *path)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102075:	31 d2                	xor    %edx,%edx
{
80102077:	89 e5                	mov    %esp,%ebp
80102079:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102082:	e8 29 fd ff ff       	call   80101db0 <namex>
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102090:	f3 0f 1e fb          	endbr32 
80102094:	55                   	push   %ebp
  return namex(path, 1, name);
80102095:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010209a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010209c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010209f:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020a2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020a3:	e9 08 fd ff ff       	jmp    80101db0 <namex>
801020a8:	66 90                	xchg   %ax,%ax
801020aa:	66 90                	xchg   %ax,%ax
801020ac:	66 90                	xchg   %ax,%ax
801020ae:	66 90                	xchg   %ax,%ax

801020b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020b9:	85 c0                	test   %eax,%eax
801020bb:	0f 84 b4 00 00 00    	je     80102175 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020c1:	8b 70 08             	mov    0x8(%eax),%esi
801020c4:	89 c3                	mov    %eax,%ebx
801020c6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020cc:	0f 87 96 00 00 00    	ja     80102168 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020de:	66 90                	xchg   %ax,%ax
801020e0:	89 ca                	mov    %ecx,%edx
801020e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e3:	83 e0 c0             	and    $0xffffffc0,%eax
801020e6:	3c 40                	cmp    $0x40,%al
801020e8:	75 f6                	jne    801020e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ea:	31 ff                	xor    %edi,%edi
801020ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020f1:	89 f8                	mov    %edi,%eax
801020f3:	ee                   	out    %al,(%dx)
801020f4:	b8 01 00 00 00       	mov    $0x1,%eax
801020f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020fe:	ee                   	out    %al,(%dx)
801020ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102104:	89 f0                	mov    %esi,%eax
80102106:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102107:	89 f0                	mov    %esi,%eax
80102109:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010210e:	c1 f8 08             	sar    $0x8,%eax
80102111:	ee                   	out    %al,(%dx)
80102112:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102117:	89 f8                	mov    %edi,%eax
80102119:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010211a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010211e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102123:	c1 e0 04             	shl    $0x4,%eax
80102126:	83 e0 10             	and    $0x10,%eax
80102129:	83 c8 e0             	or     $0xffffffe0,%eax
8010212c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010212d:	f6 03 04             	testb  $0x4,(%ebx)
80102130:	75 16                	jne    80102148 <idestart+0x98>
80102132:	b8 20 00 00 00       	mov    $0x20,%eax
80102137:	89 ca                	mov    %ecx,%edx
80102139:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010213a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213d:	5b                   	pop    %ebx
8010213e:	5e                   	pop    %esi
8010213f:	5f                   	pop    %edi
80102140:	5d                   	pop    %ebp
80102141:	c3                   	ret    
80102142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102148:	b8 30 00 00 00       	mov    $0x30,%eax
8010214d:	89 ca                	mov    %ecx,%edx
8010214f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102150:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102155:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102158:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010215d:	fc                   	cld    
8010215e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102163:	5b                   	pop    %ebx
80102164:	5e                   	pop    %esi
80102165:	5f                   	pop    %edi
80102166:	5d                   	pop    %ebp
80102167:	c3                   	ret    
    panic("incorrect blockno");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 f4 74 10 80       	push   $0x801074f4
80102170:	e8 1b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 eb 74 10 80       	push   $0x801074eb
8010217d:	e8 0e e2 ff ff       	call   80100390 <panic>
80102182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <ideinit>:
{
80102190:	f3 0f 1e fb          	endbr32 
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010219a:	68 06 75 10 80       	push   $0x80107506
8010219f:	68 80 a5 10 80       	push   $0x8010a580
801021a4:	e8 57 22 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021a9:	58                   	pop    %eax
801021aa:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801021af:	5a                   	pop    %edx
801021b0:	83 e8 01             	sub    $0x1,%eax
801021b3:	50                   	push   %eax
801021b4:	6a 0e                	push   $0xe
801021b6:	e8 b5 02 00 00       	call   80102470 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021bb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021be:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c7:	90                   	nop
801021c8:	ec                   	in     (%dx),%al
801021c9:	83 e0 c0             	and    $0xffffffc0,%eax
801021cc:	3c 40                	cmp    $0x40,%al
801021ce:	75 f8                	jne    801021c8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021d5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021da:	ee                   	out    %al,(%dx)
801021db:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021e5:	eb 0e                	jmp    801021f5 <ideinit+0x65>
801021e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ee:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021f0:	83 e9 01             	sub    $0x1,%ecx
801021f3:	74 0f                	je     80102204 <ideinit+0x74>
801021f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021f6:	84 c0                	test   %al,%al
801021f8:	74 f6                	je     801021f0 <ideinit+0x60>
      havedisk1 = 1;
801021fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102201:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102204:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102209:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010220e:	ee                   	out    %al,(%dx)
}
8010220f:	c9                   	leave  
80102210:	c3                   	ret    
80102211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop

80102220 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102220:	f3 0f 1e fb          	endbr32 
80102224:	55                   	push   %ebp
80102225:	89 e5                	mov    %esp,%ebp
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
8010222a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010222d:	68 80 a5 10 80       	push   $0x8010a580
80102232:	e8 d9 22 00 00       	call   80104510 <acquire>

  if((b = idequeue) == 0){
80102237:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	85 db                	test   %ebx,%ebx
80102242:	74 5f                	je     801022a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102244:	8b 43 58             	mov    0x58(%ebx),%eax
80102247:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010224c:	8b 33                	mov    (%ebx),%esi
8010224e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102254:	75 2b                	jne    80102281 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102256:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010225b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop
80102260:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102261:	89 c1                	mov    %eax,%ecx
80102263:	83 e1 c0             	and    $0xffffffc0,%ecx
80102266:	80 f9 40             	cmp    $0x40,%cl
80102269:	75 f5                	jne    80102260 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010226b:	a8 21                	test   $0x21,%al
8010226d:	75 12                	jne    80102281 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010226f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102272:	b9 80 00 00 00       	mov    $0x80,%ecx
80102277:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010227c:	fc                   	cld    
8010227d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010227f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102281:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102284:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102287:	83 ce 02             	or     $0x2,%esi
8010228a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010228c:	53                   	push   %ebx
8010228d:	e8 9e 1e 00 00       	call   80104130 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102292:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	74 05                	je     801022a3 <ideintr+0x83>
    idestart(idequeue);
8010229e:	e8 0d fe ff ff       	call   801020b0 <idestart>
    release(&idelock);
801022a3:	83 ec 0c             	sub    $0xc,%esp
801022a6:	68 80 a5 10 80       	push   $0x8010a580
801022ab:	e8 90 23 00 00       	call   80104640 <release>

  release(&idelock);
}
801022b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b3:	5b                   	pop    %ebx
801022b4:	5e                   	pop    %esi
801022b5:	5f                   	pop    %edi
801022b6:	5d                   	pop    %ebp
801022b7:	c3                   	ret    
801022b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop

801022c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
801022c5:	89 e5                	mov    %esp,%ebp
801022c7:	53                   	push   %ebx
801022c8:	83 ec 10             	sub    $0x10,%esp
801022cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801022d1:	50                   	push   %eax
801022d2:	e8 f9 20 00 00       	call   801043d0 <holdingsleep>
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	0f 84 cf 00 00 00    	je     801023b1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022e2:	8b 03                	mov    (%ebx),%eax
801022e4:	83 e0 06             	and    $0x6,%eax
801022e7:	83 f8 02             	cmp    $0x2,%eax
801022ea:	0f 84 b4 00 00 00    	je     801023a4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022f0:	8b 53 04             	mov    0x4(%ebx),%edx
801022f3:	85 d2                	test   %edx,%edx
801022f5:	74 0d                	je     80102304 <iderw+0x44>
801022f7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022fc:	85 c0                	test   %eax,%eax
801022fe:	0f 84 93 00 00 00    	je     80102397 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102304:	83 ec 0c             	sub    $0xc,%esp
80102307:	68 80 a5 10 80       	push   $0x8010a580
8010230c:	e8 ff 21 00 00       	call   80104510 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102311:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102316:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 c0                	test   %eax,%eax
80102322:	74 6c                	je     80102390 <iderw+0xd0>
80102324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102328:	89 c2                	mov    %eax,%edx
8010232a:	8b 40 58             	mov    0x58(%eax),%eax
8010232d:	85 c0                	test   %eax,%eax
8010232f:	75 f7                	jne    80102328 <iderw+0x68>
80102331:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102334:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102336:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010233c:	74 42                	je     80102380 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 e0 06             	and    $0x6,%eax
80102343:	83 f8 02             	cmp    $0x2,%eax
80102346:	74 23                	je     8010236b <iderw+0xab>
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 80 a5 10 80       	push   $0x8010a580
80102358:	53                   	push   %ebx
80102359:	e8 12 1c 00 00       	call   80103f70 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x90>
  }


  release(&idelock);
8010236b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave  
  release(&idelock);
80102376:	e9 c5 22 00 00       	jmp    80104640 <release>
8010237b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010237f:	90                   	nop
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 29 fd ff ff       	call   801020b0 <idestart>
80102387:	eb b5                	jmp    8010233e <iderw+0x7e>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102395:	eb 9d                	jmp    80102334 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 35 75 10 80       	push   $0x80107535
8010239f:	e8 ec df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 20 75 10 80       	push   $0x80107520
801023ac:	e8 df df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 0a 75 10 80       	push   $0x8010750a
801023b9:	e8 d2 df ff ff       	call   80100390 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023cc:	00 c0 fe 
{
801023cf:	89 e5                	mov    %esp,%ebp
801023d1:	56                   	push   %esi
801023d2:	53                   	push   %ebx
  ioapic->reg = reg;
801023d3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023da:	00 00 00 
  return ioapic->data;
801023dd:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023e3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ec:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023f2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f9:	c1 ee 10             	shr    $0x10,%esi
801023fc:	89 f0                	mov    %esi,%eax
801023fe:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102401:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102404:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102407:	39 c2                	cmp    %eax,%edx
80102409:	74 16                	je     80102421 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010240b:	83 ec 0c             	sub    $0xc,%esp
8010240e:	68 54 75 10 80       	push   $0x80107554
80102413:	e8 98 e2 ff ff       	call   801006b0 <cprintf>
80102418:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010241e:	83 c4 10             	add    $0x10,%esp
80102421:	83 c6 21             	add    $0x21,%esi
{
80102424:	ba 10 00 00 00       	mov    $0x10,%edx
80102429:	b8 20 00 00 00       	mov    $0x20,%eax
8010242e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102430:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102432:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102434:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010243a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010243d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102443:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102446:	8d 5a 01             	lea    0x1(%edx),%ebx
80102449:	83 c2 02             	add    $0x2,%edx
8010244c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010244e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102454:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010245b:	39 f0                	cmp    %esi,%eax
8010245d:	75 d1                	jne    80102430 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010245f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102462:	5b                   	pop    %ebx
80102463:	5e                   	pop    %esi
80102464:	5d                   	pop    %ebp
80102465:	c3                   	ret    
80102466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246d:	8d 76 00             	lea    0x0(%esi),%esi

80102470 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
  ioapic->reg = reg;
80102475:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010247b:	89 e5                	mov    %esp,%ebp
8010247d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102480:	8d 50 20             	lea    0x20(%eax),%edx
80102483:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102487:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102489:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102492:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102495:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102498:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010249a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024a2:	89 50 10             	mov    %edx,0x10(%eax)
}
801024a5:	5d                   	pop    %ebp
801024a6:	c3                   	ret    
801024a7:	66 90                	xchg   %ax,%ax
801024a9:	66 90                	xchg   %ax,%ax
801024ab:	66 90                	xchg   %ax,%ax
801024ad:	66 90                	xchg   %ax,%ax
801024af:	90                   	nop

801024b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024b0:	f3 0f 1e fb          	endbr32 
801024b4:	55                   	push   %ebp
801024b5:	89 e5                	mov    %esp,%ebp
801024b7:	53                   	push   %ebx
801024b8:	83 ec 04             	sub    $0x4,%esp
801024bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024be:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024c4:	75 7a                	jne    80102540 <kfree+0x90>
801024c6:	81 fb 14 59 11 80    	cmp    $0x80115914,%ebx
801024cc:	72 72                	jb     80102540 <kfree+0x90>
801024ce:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024d4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024d9:	77 65                	ja     80102540 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024db:	83 ec 04             	sub    $0x4,%esp
801024de:	68 00 10 00 00       	push   $0x1000
801024e3:	6a 01                	push   $0x1
801024e5:	53                   	push   %ebx
801024e6:	e8 a5 21 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801024eb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024f1:	83 c4 10             	add    $0x10,%esp
801024f4:	85 d2                	test   %edx,%edx
801024f6:	75 20                	jne    80102518 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024f8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024fd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024ff:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102504:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010250a:	85 c0                	test   %eax,%eax
8010250c:	75 22                	jne    80102530 <kfree+0x80>
    release(&kmem.lock);
}
8010250e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102511:	c9                   	leave  
80102512:	c3                   	ret    
80102513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102517:	90                   	nop
    acquire(&kmem.lock);
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	68 40 26 11 80       	push   $0x80112640
80102520:	e8 eb 1f 00 00       	call   80104510 <acquire>
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	eb ce                	jmp    801024f8 <kfree+0x48>
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102530:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253a:	c9                   	leave  
    release(&kmem.lock);
8010253b:	e9 00 21 00 00       	jmp    80104640 <release>
    panic("kfree");
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 86 75 10 80       	push   $0x80107586
80102548:	e8 43 de ff ff       	call   80100390 <panic>
8010254d:	8d 76 00             	lea    0x0(%esi),%esi

80102550 <freerange>:
{
80102550:	f3 0f 1e fb          	endbr32 
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102558:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010255b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010255e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010255f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102565:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102571:	39 de                	cmp    %ebx,%esi
80102573:	72 1f                	jb     80102594 <freerange+0x44>
80102575:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102587:	50                   	push   %eax
80102588:	e8 23 ff ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	39 f3                	cmp    %esi,%ebx
80102592:	76 e4                	jbe    80102578 <freerange+0x28>
}
80102594:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102597:	5b                   	pop    %ebx
80102598:	5e                   	pop    %esi
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop

801025a0 <kinit1>:
{
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	56                   	push   %esi
801025a8:	53                   	push   %ebx
801025a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025ac:	83 ec 08             	sub    $0x8,%esp
801025af:	68 8c 75 10 80       	push   $0x8010758c
801025b4:	68 40 26 11 80       	push   $0x80112640
801025b9:	e8 42 1e 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025be:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025c4:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801025cb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ce:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025e0:	39 de                	cmp    %ebx,%esi
801025e2:	72 20                	jb     80102604 <kinit1+0x64>
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 b3 fe ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit1+0x48>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	f3 0f 1e fb          	endbr32 
80102614:	55                   	push   %ebp
80102615:	89 e5                	mov    %esp,%ebp
80102617:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102618:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010261b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102625:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102631:	39 de                	cmp    %ebx,%esi
80102633:	72 1f                	jb     80102654 <kinit2+0x44>
80102635:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 63 fe ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret    
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102670:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102674:	a1 74 26 11 80       	mov    0x80112674,%eax
80102679:	85 c0                	test   %eax,%eax
8010267b:	75 1b                	jne    80102698 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010267d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102682:	85 c0                	test   %eax,%eax
80102684:	74 0a                	je     80102690 <kalloc+0x20>
    kmem.freelist = r->next;
80102686:	8b 10                	mov    (%eax),%edx
80102688:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010268e:	c3                   	ret    
8010268f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102690:	c3                   	ret    
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102698:	55                   	push   %ebp
80102699:	89 e5                	mov    %esp,%ebp
8010269b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010269e:	68 40 26 11 80       	push   $0x80112640
801026a3:	e8 68 1e 00 00       	call   80104510 <acquire>
  r = kmem.freelist;
801026a8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ad:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026b3:	83 c4 10             	add    $0x10,%esp
801026b6:	85 c0                	test   %eax,%eax
801026b8:	74 08                	je     801026c2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ba:	8b 08                	mov    (%eax),%ecx
801026bc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026c2:	85 d2                	test   %edx,%edx
801026c4:	74 16                	je     801026dc <kalloc+0x6c>
    release(&kmem.lock);
801026c6:	83 ec 0c             	sub    $0xc,%esp
801026c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026cc:	68 40 26 11 80       	push   $0x80112640
801026d1:	e8 6a 1f 00 00       	call   80104640 <release>
  return (char*)r;
801026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026d9:	83 c4 10             	add    $0x10,%esp
}
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026e0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e4:	ba 64 00 00 00       	mov    $0x64,%edx
801026e9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ea:	a8 01                	test   $0x1,%al
801026ec:	0f 84 be 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026f2:	55                   	push   %ebp
801026f3:	ba 60 00 00 00       	mov    $0x60,%edx
801026f8:	89 e5                	mov    %esp,%ebp
801026fa:	53                   	push   %ebx
801026fb:	ec                   	in     (%dx),%al
  return data;
801026fc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102702:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102705:	3c e0                	cmp    $0xe0,%al
80102707:	74 57                	je     80102760 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102709:	89 d9                	mov    %ebx,%ecx
8010270b:	83 e1 40             	and    $0x40,%ecx
8010270e:	84 c0                	test   %al,%al
80102710:	78 5e                	js     80102770 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102712:	85 c9                	test   %ecx,%ecx
80102714:	74 09                	je     8010271f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102716:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102719:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010271c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010271f:	0f b6 8a c0 76 10 80 	movzbl -0x7fef8940(%edx),%ecx
  shift ^= togglecode[data];
80102726:	0f b6 82 c0 75 10 80 	movzbl -0x7fef8a40(%edx),%eax
  shift |= shiftcode[data];
8010272d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010272f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102731:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102733:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102739:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010273c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273f:	8b 04 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%eax
80102746:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010274a:	74 0b                	je     80102757 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010274c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274f:	83 fa 19             	cmp    $0x19,%edx
80102752:	77 44                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102754:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102757:	5b                   	pop    %ebx
80102758:	5d                   	pop    %ebp
80102759:	c3                   	ret    
8010275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010276b:	5b                   	pop    %ebx
8010276c:	5d                   	pop    %ebp
8010276d:	c3                   	ret    
8010276e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 c9                	test   %ecx,%ecx
80102775:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102778:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010277a:	0f b6 8a c0 76 10 80 	movzbl -0x7fef8940(%edx),%ecx
80102781:	83 c9 40             	or     $0x40,%ecx
80102784:	0f b6 c9             	movzbl %cl,%ecx
80102787:	f7 d1                	not    %ecx
80102789:	21 d9                	and    %ebx,%ecx
}
8010278b:	5b                   	pop    %ebx
8010278c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010278d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	5b                   	pop    %ebx
8010279f:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027a0:	83 f9 1a             	cmp    $0x1a,%ecx
801027a3:	0f 42 c2             	cmovb  %edx,%eax
}
801027a6:	c3                   	ret    
801027a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ae:	66 90                	xchg   %ax,%ax
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret    
801027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	f3 0f 1e fb          	endbr32 
801027c4:	55                   	push   %ebp
801027c5:	89 e5                	mov    %esp,%ebp
801027c7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027ca:	68 e0 26 10 80       	push   $0x801026e0
801027cf:	e8 8c e0 ff ff       	call   80100860 <consoleintr>
}
801027d4:	83 c4 10             	add    $0x10,%esp
801027d7:	c9                   	leave  
801027d8:	c3                   	ret    
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027e0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027e4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027e9:	85 c0                	test   %eax,%eax
801027eb:	0f 84 c7 00 00 00    	je     801028b8 <lapicinit+0xd8>
  lapic[index] = value;
801027f1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fe:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102805:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102808:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102812:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102818:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102822:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102825:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010282c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102832:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102839:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283f:	8b 50 30             	mov    0x30(%eax),%edx
80102842:	c1 ea 10             	shr    $0x10,%edx
80102845:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010284b:	75 73                	jne    801028c0 <lapicinit+0xe0>
  lapic[index] = value;
8010284d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102854:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102861:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102867:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102871:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102874:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010287b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102881:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102888:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102895:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102898:	8b 50 20             	mov    0x20(%eax),%edx
8010289b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028a6:	80 e6 10             	and    $0x10,%dh
801028a9:	75 f5                	jne    801028a0 <lapicinit+0xc0>
  lapic[index] = value;
801028ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b8:	c3                   	ret    
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ca:	8b 50 20             	mov    0x20(%eax),%edx
}
801028cd:	e9 7b ff ff ff       	jmp    8010284d <lapicinit+0x6d>
801028d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028e0 <lapicid>:

int
lapicid(void)
{
801028e0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028e4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028e9:	85 c0                	test   %eax,%eax
801028eb:	74 0b                	je     801028f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ed:	8b 40 20             	mov    0x20(%eax),%eax
801028f0:	c1 e8 18             	shr    $0x18,%eax
801028f3:	c3                   	ret    
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028f8:	31 c0                	xor    %eax,%eax
}
801028fa:	c3                   	ret    
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102900:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102904:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102909:	85 c0                	test   %eax,%eax
8010290b:	74 0d                	je     8010291a <lapiceoi+0x1a>
  lapic[index] = value;
8010290d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102914:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010291a:	c3                   	ret    
8010291b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102920:	f3 0f 1e fb          	endbr32 
}
80102924:	c3                   	ret    
80102925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102930 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102930:	f3 0f 1e fb          	endbr32 
80102934:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	b8 0f 00 00 00       	mov    $0xf,%eax
8010293a:	ba 70 00 00 00       	mov    $0x70,%edx
8010293f:	89 e5                	mov    %esp,%ebp
80102941:	53                   	push   %ebx
80102942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102945:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102948:	ee                   	out    %al,(%dx)
80102949:	b8 0a 00 00 00       	mov    $0xa,%eax
8010294e:	ba 71 00 00 00       	mov    $0x71,%edx
80102953:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102954:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102956:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102959:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010295f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102961:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102964:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102966:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102969:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010296c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102972:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102977:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010297d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102980:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102987:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102994:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102997:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ac:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029bb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029bf:	5d                   	pop    %ebp
801029c0:	c3                   	ret    
801029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801029d0:	f3 0f 1e fb          	endbr32 
801029d4:	55                   	push   %ebp
801029d5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029da:	ba 70 00 00 00       	mov    $0x70,%edx
801029df:	89 e5                	mov    %esp,%ebp
801029e1:	57                   	push   %edi
801029e2:	56                   	push   %esi
801029e3:	53                   	push   %ebx
801029e4:	83 ec 4c             	sub    $0x4c,%esp
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ed:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ee:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a00:	31 c0                	xor    %eax,%eax
80102a02:	89 da                	mov    %ebx,%edx
80102a04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a05:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a0a:	89 ca                	mov    %ecx,%edx
80102a0c:	ec                   	in     (%dx),%al
80102a0d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a10:	89 da                	mov    %ebx,%edx
80102a12:	b8 02 00 00 00       	mov    $0x2,%eax
80102a17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a18:	89 ca                	mov    %ecx,%edx
80102a1a:	ec                   	in     (%dx),%al
80102a1b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1e:	89 da                	mov    %ebx,%edx
80102a20:	b8 04 00 00 00       	mov    $0x4,%eax
80102a25:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a26:	89 ca                	mov    %ecx,%edx
80102a28:	ec                   	in     (%dx),%al
80102a29:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	89 ca                	mov    %ecx,%edx
80102a36:	ec                   	in     (%dx),%al
80102a37:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3a:	89 da                	mov    %ebx,%edx
80102a3c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a41:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a42:	89 ca                	mov    %ecx,%edx
80102a44:	ec                   	in     (%dx),%al
80102a45:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a47:	89 da                	mov    %ebx,%edx
80102a49:	b8 09 00 00 00       	mov    $0x9,%eax
80102a4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4f:	89 ca                	mov    %ecx,%edx
80102a51:	ec                   	in     (%dx),%al
80102a52:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 da                	mov    %ebx,%edx
80102a56:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a5f:	84 c0                	test   %al,%al
80102a61:	78 9d                	js     80102a00 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a63:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a67:	89 fa                	mov    %edi,%edx
80102a69:	0f b6 fa             	movzbl %dl,%edi
80102a6c:	89 f2                	mov    %esi,%edx
80102a6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a71:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a75:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 da                	mov    %ebx,%edx
80102a7a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a7d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a80:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a84:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a87:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a8a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a91:	31 c0                	xor    %eax,%eax
80102a93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a94:	89 ca                	mov    %ecx,%edx
80102a96:	ec                   	in     (%dx),%al
80102a97:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9a:	89 da                	mov    %ebx,%edx
80102a9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a9f:	b8 02 00 00 00       	mov    $0x2,%eax
80102aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa5:	89 ca                	mov    %ecx,%edx
80102aa7:	ec                   	in     (%dx),%al
80102aa8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aab:	89 da                	mov    %ebx,%edx
80102aad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ab5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab6:	89 ca                	mov    %ecx,%edx
80102ab8:	ec                   	in     (%dx),%al
80102ab9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abc:	89 da                	mov    %ebx,%edx
80102abe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ac6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac7:	89 ca                	mov    %ecx,%edx
80102ac9:	ec                   	in     (%dx),%al
80102aca:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acd:	89 da                	mov    %ebx,%edx
80102acf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ad2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ad7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad8:	89 ca                	mov    %ecx,%edx
80102ada:	ec                   	in     (%dx),%al
80102adb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ade:	89 da                	mov    %ebx,%edx
80102ae0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ae3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae9:	89 ca                	mov    %ecx,%edx
80102aeb:	ec                   	in     (%dx),%al
80102aec:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aef:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af8:	6a 18                	push   $0x18
80102afa:	50                   	push   %eax
80102afb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102afe:	50                   	push   %eax
80102aff:	e8 dc 1b 00 00       	call   801046e0 <memcmp>
80102b04:	83 c4 10             	add    $0x10,%esp
80102b07:	85 c0                	test   %eax,%eax
80102b09:	0f 85 f1 fe ff ff    	jne    80102a00 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b0f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b13:	75 78                	jne    80102b8d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b15:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	83 e0 0f             	and    $0xf,%eax
80102b1d:	c1 ea 04             	shr    $0x4,%edx
80102b20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b26:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b29:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	83 e0 0f             	and    $0xf,%eax
80102b31:	c1 ea 04             	shr    $0x4,%edx
80102b34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b3d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b65:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	83 e0 0f             	and    $0xf,%eax
80102b6d:	c1 ea 04             	shr    $0x4,%edx
80102b70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b76:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b79:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b7c:	89 c2                	mov    %eax,%edx
80102b7e:	83 e0 0f             	and    $0xf,%eax
80102b81:	c1 ea 04             	shr    $0x4,%edx
80102b84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b8d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b90:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b93:	89 06                	mov    %eax,(%esi)
80102b95:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b98:	89 46 04             	mov    %eax,0x4(%esi)
80102b9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b9e:	89 46 08             	mov    %eax,0x8(%esi)
80102ba1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ba4:	89 46 0c             	mov    %eax,0xc(%esi)
80102ba7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102baa:	89 46 10             	mov    %eax,0x10(%esi)
80102bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bb3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bbd:	5b                   	pop    %ebx
80102bbe:	5e                   	pop    %esi
80102bbf:	5f                   	pop    %edi
80102bc0:	5d                   	pop    %ebp
80102bc1:	c3                   	ret    
80102bc2:	66 90                	xchg   %ax,%ax
80102bc4:	66 90                	xchg   %ax,%ax
80102bc6:	66 90                	xchg   %ax,%ax
80102bc8:	66 90                	xchg   %ax,%ax
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102c14:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 f7 1a 00 00       	call   80104730 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c7d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	f3 0f 1e fb          	endbr32 
80102cd4:	55                   	push   %ebp
80102cd5:	89 e5                	mov    %esp,%ebp
80102cd7:	53                   	push   %ebx
80102cd8:	83 ec 2c             	sub    $0x2c,%esp
80102cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cde:	68 c0 77 10 80       	push   $0x801077c0
80102ce3:	68 80 26 11 80       	push   $0x80112680
80102ce8:	e8 13 17 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102ced:	58                   	pop    %eax
80102cee:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cf1:	5a                   	pop    %edx
80102cf2:	50                   	push   %eax
80102cf3:	53                   	push   %ebx
80102cf4:	e8 c7 e7 ff ff       	call   801014c0 <readsb>
  log.start = sb.logstart;
80102cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cfc:	59                   	pop    %ecx
  log.dev = dev;
80102cfd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102d03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d06:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102d0b:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102d11:	5a                   	pop    %edx
80102d12:	50                   	push   %eax
80102d13:	53                   	push   %ebx
80102d14:	e8 b7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d19:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d1c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d1f:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102d25:	85 c9                	test   %ecx,%ecx
80102d27:	7e 19                	jle    80102d42 <initlog+0x72>
80102d29:	31 d2                	xor    %edx,%edx
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d30:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d34:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d1                	cmp    %edx,%ecx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	f3 0f 1e fb          	endbr32 
80102d74:	55                   	push   %ebp
80102d75:	89 e5                	mov    %esp,%ebp
80102d77:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d7a:	68 80 26 11 80       	push   $0x80112680
80102d7f:	e8 8c 17 00 00       	call   80104510 <acquire>
80102d84:	83 c4 10             	add    $0x10,%esp
80102d87:	eb 1c                	jmp    80102da5 <begin_op+0x35>
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d90:	83 ec 08             	sub    $0x8,%esp
80102d93:	68 80 26 11 80       	push   $0x80112680
80102d98:	68 80 26 11 80       	push   $0x80112680
80102d9d:	e8 ce 11 00 00       	call   80103f70 <sleep>
80102da2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102da5:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102daa:	85 c0                	test   %eax,%eax
80102dac:	75 e2                	jne    80102d90 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dae:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102db3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102db9:	83 c0 01             	add    $0x1,%eax
80102dbc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dbf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dc2:	83 fa 1e             	cmp    $0x1e,%edx
80102dc5:	7f c9                	jg     80102d90 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dc7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dca:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102dcf:	68 80 26 11 80       	push   $0x80112680
80102dd4:	e8 67 18 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	c9                   	leave  
80102ddd:	c3                   	ret    
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	f3 0f 1e fb          	endbr32 
80102de4:	55                   	push   %ebp
80102de5:	89 e5                	mov    %esp,%ebp
80102de7:	57                   	push   %edi
80102de8:	56                   	push   %esi
80102de9:	53                   	push   %ebx
80102dea:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ded:	68 80 26 11 80       	push   $0x80112680
80102df2:	e8 19 17 00 00       	call   80104510 <acquire>
  log.outstanding -= 1;
80102df7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dfc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102e02:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e05:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e08:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102e0e:	85 f6                	test   %esi,%esi
80102e10:	0f 85 1e 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e16:	85 db                	test   %ebx,%ebx
80102e18:	0f 85 f2 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1e:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102e25:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e28:	83 ec 0c             	sub    $0xc,%esp
80102e2b:	68 80 26 11 80       	push   $0x80112680
80102e30:	e8 0b 18 00 00       	call   80104640 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e35:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e3b:	83 c4 10             	add    $0x10,%esp
80102e3e:	85 c9                	test   %ecx,%ecx
80102e40:	7f 3e                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	68 80 26 11 80       	push   $0x80112680
80102e4a:	e8 c1 16 00 00       	call   80104510 <acquire>
    wakeup(&log);
80102e4f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e56:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e5d:	00 00 00 
    wakeup(&log);
80102e60:	e8 cb 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102e65:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e6c:	e8 cf 17 00 00       	call   80104640 <release>
80102e71:	83 c4 10             	add    $0x10,%esp
}
80102e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e77:	5b                   	pop    %ebx
80102e78:	5e                   	pop    %esi
80102e79:	5f                   	pop    %edi
80102e7a:	5d                   	pop    %ebp
80102e7b:	c3                   	ret    
80102e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ea4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 67 18 00 00       	call   80104730 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 38 ff ff ff       	jmp    80102e42 <end_op+0x62>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 80 26 11 80       	push   $0x80112680
80102f18:	e8 13 12 00 00       	call   80104130 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102f24:	e8 17 17 00 00       	call   80104640 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 c4 77 10 80       	push   $0x801077c4
80102f3c:	e8 4f d4 ff ff       	call   80100390 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	f3 0f 1e fb          	endbr32 
80102f54:	55                   	push   %ebp
80102f55:	89 e5                	mov    %esp,%ebp
80102f57:	53                   	push   %ebx
80102f58:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f61:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f64:	83 fa 1d             	cmp    $0x1d,%edx
80102f67:	0f 8f 91 00 00 00    	jg     80102ffe <log_write+0xae>
80102f6d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f72:	83 e8 01             	sub    $0x1,%eax
80102f75:	39 c2                	cmp    %eax,%edx
80102f77:	0f 8d 81 00 00 00    	jge    80102ffe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f7d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f82:	85 c0                	test   %eax,%eax
80102f84:	0f 8e 81 00 00 00    	jle    8010300b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f8a:	83 ec 0c             	sub    $0xc,%esp
80102f8d:	68 80 26 11 80       	push   $0x80112680
80102f92:	e8 79 15 00 00       	call   80104510 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f97:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f9d:	83 c4 10             	add    $0x10,%esp
80102fa0:	85 d2                	test   %edx,%edx
80102fa2:	7e 4e                	jle    80102ff2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fa7:	31 c0                	xor    %eax,%eax
80102fa9:	eb 0c                	jmp    80102fb7 <log_write+0x67>
80102fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	39 c2                	cmp    %eax,%edx
80102fb5:	74 29                	je     80102fe0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb7:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102fbe:	75 f0                	jne    80102fb0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fc7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fcd:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102fd4:	c9                   	leave  
  release(&log.lock);
80102fd5:	e9 66 16 00 00       	jmp    80104640 <release>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fe7:	83 c2 01             	add    $0x1,%edx
80102fea:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102ff0:	eb d5                	jmp    80102fc7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102ff2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102ffa:	75 cb                	jne    80102fc7 <log_write+0x77>
80102ffc:	eb e9                	jmp    80102fe7 <log_write+0x97>
    panic("too big a transaction");
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 d3 77 10 80       	push   $0x801077d3
80103006:	e8 85 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	68 e9 77 10 80       	push   $0x801077e9
80103013:	e8 78 d3 ff ff       	call   80100390 <panic>
80103018:	66 90                	xchg   %ax,%ax
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 64 09 00 00       	call   80103990 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 5d 09 00 00       	call   80103990 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 04 78 10 80       	push   $0x80107804
8010303d:	e8 6e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 29 29 00 00       	call   80105970 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 d4 08 00 00       	call   80103920 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 21 0c 00 00       	call   80103c80 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	f3 0f 1e fb          	endbr32 
80103064:	55                   	push   %ebp
80103065:	89 e5                	mov    %esp,%ebp
80103067:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010306a:	e8 31 3a 00 00       	call   80106aa0 <switchkvm>
  seginit();
8010306f:	e8 0c 39 00 00       	call   80106980 <seginit>
  lapicinit();
80103074:	e8 67 f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103079:	e8 a2 ff ff ff       	call   80103020 <mpmain>
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	f3 0f 1e fb          	endbr32 
80103084:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103088:	83 e4 f0             	and    $0xfffffff0,%esp
8010308b:	ff 71 fc             	pushl  -0x4(%ecx)
8010308e:	55                   	push   %ebp
8010308f:	89 e5                	mov    %esp,%ebp
80103091:	53                   	push   %ebx
80103092:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103093:	83 ec 08             	sub    $0x8,%esp
80103096:	68 00 00 40 80       	push   $0x80400000
8010309b:	68 14 59 11 80       	push   $0x80115914
801030a0:	e8 fb f4 ff ff       	call   801025a0 <kinit1>
  kvmalloc();      // kernel page table
801030a5:	e8 26 3f 00 00       	call   80106fd0 <kvmalloc>
  mpinit();        // detect other processors
801030aa:	e8 91 01 00 00       	call   80103240 <mpinit>
  lapicinit();     // interrupt controller
801030af:	e8 2c f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
801030b4:	e8 c7 38 00 00       	call   80106980 <seginit>
  picinit();       // disable pic
801030b9:	e8 62 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030be:	e8 fd f2 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
801030c3:	e8 68 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030c8:	e8 03 2c 00 00       	call   80105cd0 <uartinit>
  pinit();         // process table
801030cd:	e8 2e 08 00 00       	call   80103900 <pinit>
  shminit();       // shared memory
801030d2:	e8 b9 41 00 00       	call   80107290 <shminit>
  tvinit();        // trap vectors
801030d7:	e8 14 28 00 00       	call   801058f0 <tvinit>
  binit();         // buffer cache
801030dc:	e8 5f cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030e1:	e8 3a dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030e6:	e8 a5 f0 ff ff       	call   80102190 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030eb:	83 c4 0c             	add    $0xc,%esp
801030ee:	68 8a 00 00 00       	push   $0x8a
801030f3:	68 8c a4 10 80       	push   $0x8010a48c
801030f8:	68 00 70 00 80       	push   $0x80007000
801030fd:	e8 2e 16 00 00       	call   80104730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103102:	83 c4 10             	add    $0x10,%esp
80103105:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
8010310c:	00 00 00 
8010310f:	05 80 27 11 80       	add    $0x80112780,%eax
80103114:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103119:	76 7d                	jbe    80103198 <main+0x118>
8010311b:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103120:	eb 1f                	jmp    80103141 <main+0xc1>
80103122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103128:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
8010312f:	00 00 00 
80103132:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103138:	05 80 27 11 80       	add    $0x80112780,%eax
8010313d:	39 c3                	cmp    %eax,%ebx
8010313f:	73 57                	jae    80103198 <main+0x118>
    if(c == mycpu())  // We've started already.
80103141:	e8 da 07 00 00       	call   80103920 <mycpu>
80103146:	39 c3                	cmp    %eax,%ebx
80103148:	74 de                	je     80103128 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010314a:	e8 21 f5 ff ff       	call   80102670 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010314f:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
80103152:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103159:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010315c:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103163:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103166:	05 00 10 00 00       	add    $0x1000,%eax
8010316b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103170:	0f b6 03             	movzbl (%ebx),%eax
80103173:	68 00 70 00 00       	push   $0x7000
80103178:	50                   	push   %eax
80103179:	e8 b2 f7 ff ff       	call   80102930 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010317e:	83 c4 10             	add    $0x10,%esp
80103181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103188:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010318e:	85 c0                	test   %eax,%eax
80103190:	74 f6                	je     80103188 <main+0x108>
80103192:	eb 94                	jmp    80103128 <main+0xa8>
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103198:	83 ec 08             	sub    $0x8,%esp
8010319b:	68 00 00 00 8e       	push   $0x8e000000
801031a0:	68 00 00 40 80       	push   $0x80400000
801031a5:	e8 66 f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801031aa:	e8 31 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
801031af:	e8 6c fe ff ff       	call   80103020 <mpmain>
801031b4:	66 90                	xchg   %ax,%ax
801031b6:	66 90                	xchg   %ax,%ax
801031b8:	66 90                	xchg   %ax,%ax
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031cb:	53                   	push   %ebx
  e = addr+len;
801031cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031d2:	39 de                	cmp    %ebx,%esi
801031d4:	72 10                	jb     801031e6 <mpsearch1+0x26>
801031d6:	eb 50                	jmp    80103228 <mpsearch1+0x68>
801031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop
801031e0:	89 fe                	mov    %edi,%esi
801031e2:	39 fb                	cmp    %edi,%ebx
801031e4:	76 42                	jbe    80103228 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e6:	83 ec 04             	sub    $0x4,%esp
801031e9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ec:	6a 04                	push   $0x4
801031ee:	68 18 78 10 80       	push   $0x80107818
801031f3:	56                   	push   %esi
801031f4:	e8 e7 14 00 00       	call   801046e0 <memcmp>
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	75 e0                	jne    801031e0 <mpsearch1+0x20>
80103200:	89 f2                	mov    %esi,%edx
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103208:	0f b6 0a             	movzbl (%edx),%ecx
8010320b:	83 c2 01             	add    $0x1,%edx
8010320e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103210:	39 fa                	cmp    %edi,%edx
80103212:	75 f4                	jne    80103208 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103214:	84 c0                	test   %al,%al
80103216:	75 c8                	jne    801031e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321b:	89 f0                	mov    %esi,%eax
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010322b:	31 f6                	xor    %esi,%esi
}
8010322d:	5b                   	pop    %ebx
8010322e:	89 f0                	mov    %esi,%eax
80103230:	5e                   	pop    %esi
80103231:	5f                   	pop    %edi
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    
80103234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	57                   	push   %edi
80103248:	56                   	push   %esi
80103249:	53                   	push   %ebx
8010324a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010324d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103254:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010325b:	c1 e0 08             	shl    $0x8,%eax
8010325e:	09 d0                	or     %edx,%eax
80103260:	c1 e0 04             	shl    $0x4,%eax
80103263:	75 1b                	jne    80103280 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103265:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010326c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103273:	c1 e0 08             	shl    $0x8,%eax
80103276:	09 d0                	or     %edx,%eax
80103278:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010327b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103280:	ba 00 04 00 00       	mov    $0x400,%edx
80103285:	e8 36 ff ff ff       	call   801031c0 <mpsearch1>
8010328a:	89 c6                	mov    %eax,%esi
8010328c:	85 c0                	test   %eax,%eax
8010328e:	0f 84 4c 01 00 00    	je     801033e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103294:	8b 5e 04             	mov    0x4(%esi),%ebx
80103297:	85 db                	test   %ebx,%ebx
80103299:	0f 84 61 01 00 00    	je     80103400 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032a8:	6a 04                	push   $0x4
801032aa:	68 1d 78 10 80       	push   $0x8010781d
801032af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b3:	e8 28 14 00 00       	call   801046e0 <memcmp>
801032b8:	83 c4 10             	add    $0x10,%esp
801032bb:	85 c0                	test   %eax,%eax
801032bd:	0f 85 3d 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032ca:	3c 01                	cmp    $0x1,%al
801032cc:	74 08                	je     801032d6 <mpinit+0x96>
801032ce:	3c 04                	cmp    $0x4,%al
801032d0:	0f 85 2a 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032dd:	66 85 d2             	test   %dx,%dx
801032e0:	74 26                	je     80103308 <mpinit+0xc8>
801032e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032e7:	31 d2                	xor    %edx,%edx
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032f7:	83 c0 01             	add    $0x1,%eax
801032fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032fc:	39 f8                	cmp    %edi,%eax
801032fe:	75 f0                	jne    801032f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103300:	84 d2                	test   %dl,%dl
80103302:	0f 85 f8 00 00 00    	jne    80103400 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103308:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010330e:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103313:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103319:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103320:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103325:	03 55 e4             	add    -0x1c(%ebp),%edx
80103328:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010332b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop
80103330:	39 c2                	cmp    %eax,%edx
80103332:	76 15                	jbe    80103349 <mpinit+0x109>
    switch(*p){
80103334:	0f b6 08             	movzbl (%eax),%ecx
80103337:	80 f9 02             	cmp    $0x2,%cl
8010333a:	74 5c                	je     80103398 <mpinit+0x158>
8010333c:	77 42                	ja     80103380 <mpinit+0x140>
8010333e:	84 c9                	test   %cl,%cl
80103340:	74 6e                	je     801033b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103342:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103345:	39 c2                	cmp    %eax,%edx
80103347:	77 eb                	ja     80103334 <mpinit+0xf4>
80103349:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010334c:	85 db                	test   %ebx,%ebx
8010334e:	0f 84 b9 00 00 00    	je     8010340d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103354:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103358:	74 15                	je     8010336f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335a:	b8 70 00 00 00       	mov    $0x70,%eax
8010335f:	ba 22 00 00 00       	mov    $0x22,%edx
80103364:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103365:	ba 23 00 00 00       	mov    $0x23,%edx
8010336a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010336b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	ee                   	out    %al,(%dx)
  }
}
8010336f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5f                   	pop    %edi
80103375:	5d                   	pop    %ebp
80103376:	c3                   	ret    
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	76 ba                	jbe    80103342 <mpinit+0x102>
80103388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010338f:	eb 9f                	jmp    80103330 <mpinit+0xf0>
80103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103398:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010339c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010339f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801033a5:	eb 89                	jmp    80103330 <mpinit+0xf0>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033b0:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801033b6:	83 f9 07             	cmp    $0x7,%ecx
801033b9:	7f 19                	jg     801033d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033c5:	83 c1 01             	add    $0x1,%ecx
801033c8:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ce:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801033d4:	83 c0 14             	add    $0x14,%eax
      continue;
801033d7:	e9 54 ff ff ff       	jmp    80103330 <mpinit+0xf0>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ea:	e8 d1 fd ff ff       	call   801031c0 <mpsearch1>
801033ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f1:	85 c0                	test   %eax,%eax
801033f3:	0f 85 9b fe ff ff    	jne    80103294 <mpinit+0x54>
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 22 78 10 80       	push   $0x80107822
80103408:	e8 83 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010340d:	83 ec 0c             	sub    $0xc,%esp
80103410:	68 3c 78 10 80       	push   $0x8010783c
80103415:	e8 76 cf ff ff       	call   80100390 <panic>
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	f3 0f 1e fb          	endbr32 
80103424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103429:	ba 21 00 00 00       	mov    $0x21,%edx
8010342e:	ee                   	out    %al,(%dx)
8010342f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103434:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	f3 0f 1e fb          	endbr32 
80103444:	55                   	push   %ebp
80103445:	89 e5                	mov    %esp,%ebp
80103447:	57                   	push   %edi
80103448:	56                   	push   %esi
80103449:	53                   	push   %ebx
8010344a:	83 ec 0c             	sub    $0xc,%esp
8010344d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103450:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103453:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103459:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345f:	e8 dc d9 ff ff       	call   80100e40 <filealloc>
80103464:	89 03                	mov    %eax,(%ebx)
80103466:	85 c0                	test   %eax,%eax
80103468:	0f 84 ac 00 00 00    	je     8010351a <pipealloc+0xda>
8010346e:	e8 cd d9 ff ff       	call   80100e40 <filealloc>
80103473:	89 06                	mov    %eax,(%esi)
80103475:	85 c0                	test   %eax,%eax
80103477:	0f 84 8b 00 00 00    	je     80103508 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010347d:	e8 ee f1 ff ff       	call   80102670 <kalloc>
80103482:	89 c7                	mov    %eax,%edi
80103484:	85 c0                	test   %eax,%eax
80103486:	0f 84 b4 00 00 00    	je     80103540 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010348c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103493:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103496:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103499:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034a0:	00 00 00 
  p->nwrite = 0;
801034a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034aa:	00 00 00 
  p->nread = 0;
801034ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b4:	00 00 00 
  initlock(&p->lock, "pipe");
801034b7:	68 5b 78 10 80       	push   $0x8010785b
801034bc:	50                   	push   %eax
801034bd:	e8 3e 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
801034c2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034cd:	8b 03                	mov    (%ebx),%eax
801034cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034d3:	8b 03                	mov    (%ebx),%eax
801034d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e6:	8b 06                	mov    (%esi),%eax
801034e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ec:	8b 06                	mov    (%esi),%eax
801034ee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fa:	31 c0                	xor    %eax,%eax
}
801034fc:	5b                   	pop    %ebx
801034fd:	5e                   	pop    %esi
801034fe:	5f                   	pop    %edi
801034ff:	5d                   	pop    %ebp
80103500:	c3                   	ret    
80103501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103508:	8b 03                	mov    (%ebx),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 1e                	je     8010352c <pipealloc+0xec>
    fileclose(*f0);
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	50                   	push   %eax
80103512:	e8 e9 d9 ff ff       	call   80100f00 <fileclose>
80103517:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010351a:	8b 06                	mov    (%esi),%eax
8010351c:	85 c0                	test   %eax,%eax
8010351e:	74 0c                	je     8010352c <pipealloc+0xec>
    fileclose(*f1);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	50                   	push   %eax
80103524:	e8 d7 d9 ff ff       	call   80100f00 <fileclose>
80103529:	83 c4 10             	add    $0x10,%esp
}
8010352c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010352f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103534:	5b                   	pop    %ebx
80103535:	5e                   	pop    %esi
80103536:	5f                   	pop    %edi
80103537:	5d                   	pop    %ebp
80103538:	c3                   	ret    
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103540:	8b 03                	mov    (%ebx),%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	75 c8                	jne    8010350e <pipealloc+0xce>
80103546:	eb d2                	jmp    8010351a <pipealloc+0xda>
80103548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	56                   	push   %esi
80103558:	53                   	push   %ebx
80103559:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010355c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	53                   	push   %ebx
80103563:	e8 a8 0f 00 00       	call   80104510 <acquire>
  if(writable){
80103568:	83 c4 10             	add    $0x10,%esp
8010356b:	85 f6                	test   %esi,%esi
8010356d:	74 41                	je     801035b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103578:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357f:	00 00 00 
    wakeup(&p->nread);
80103582:	50                   	push   %eax
80103583:	e8 a8 0b 00 00       	call   80104130 <wakeup>
80103588:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010358b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	75 0a                	jne    8010359f <pipeclose+0x4f>
80103595:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010359b:	85 c0                	test   %eax,%eax
8010359d:	74 31                	je     801035d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a5:	5b                   	pop    %ebx
801035a6:	5e                   	pop    %esi
801035a7:	5d                   	pop    %ebp
    release(&p->lock);
801035a8:	e9 93 10 00 00       	jmp    80104640 <release>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 67 0b 00 00       	call   80104130 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb bd                	jmp    8010358b <pipeclose+0x3b>
801035ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 67 10 00 00       	call   80104640 <release>
    kfree((char*)p);
801035d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035dc:	83 c4 10             	add    $0x10,%esp
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 c6 ee ff ff       	jmp    801024b0 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	57                   	push   %edi
801035f8:	56                   	push   %esi
801035f9:	53                   	push   %ebx
801035fa:	83 ec 28             	sub    $0x28,%esp
801035fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103600:	53                   	push   %ebx
80103601:	e8 0a 0f 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++){
80103606:	8b 45 10             	mov    0x10(%ebp),%eax
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	85 c0                	test   %eax,%eax
8010360e:	0f 8e bc 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103614:	8b 45 0c             	mov    0xc(%ebp),%eax
80103617:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010361d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103626:	03 45 10             	add    0x10(%ebp),%eax
80103629:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010362c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103632:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103638:	89 ca                	mov    %ecx,%edx
8010363a:	05 00 02 00 00       	add    $0x200,%eax
8010363f:	39 c1                	cmp    %eax,%ecx
80103641:	74 3b                	je     8010367e <pipewrite+0x8e>
80103643:	eb 63                	jmp    801036a8 <pipewrite+0xb8>
80103645:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 63 03 00 00       	call   801039b0 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 d3 0a 00 00       	call   80104130 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 0a 09 00 00       	call   80103f70 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 af 0f 00 00       	call   80104640 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 5c ff ff ff    	jne    8010362c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 51 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 59 0f 00 00       	call   80104640 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	f3 0f 1e fb          	endbr32 
801036f4:	55                   	push   %ebp
801036f5:	89 e5                	mov    %esp,%ebp
801036f7:	57                   	push   %edi
801036f8:	56                   	push   %esi
801036f9:	53                   	push   %ebx
801036fa:	83 ec 18             	sub    $0x18,%esp
801036fd:	8b 75 08             	mov    0x8(%ebp),%esi
80103700:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103703:	56                   	push   %esi
80103704:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010370a:	e8 01 0e 00 00       	call   80104510 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371e:	74 33                	je     80103753 <piperead+0x63>
80103720:	eb 3b                	jmp    8010375d <piperead+0x6d>
80103722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103728:	e8 83 02 00 00       	call   801039b0 <myproc>
8010372d:	8b 48 24             	mov    0x24(%eax),%ecx
80103730:	85 c9                	test   %ecx,%ecx
80103732:	0f 85 88 00 00 00    	jne    801037c0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103738:	83 ec 08             	sub    $0x8,%esp
8010373b:	56                   	push   %esi
8010373c:	53                   	push   %ebx
8010373d:	e8 2e 08 00 00       	call   80103f70 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103742:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103748:	83 c4 10             	add    $0x10,%esp
8010374b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103751:	75 0a                	jne    8010375d <piperead+0x6d>
80103753:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103759:	85 c0                	test   %eax,%eax
8010375b:	75 cb                	jne    80103728 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010375d:	8b 55 10             	mov    0x10(%ebp),%edx
80103760:	31 db                	xor    %ebx,%ebx
80103762:	85 d2                	test   %edx,%edx
80103764:	7f 28                	jg     8010378e <piperead+0x9e>
80103766:	eb 34                	jmp    8010379c <piperead+0xac>
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103770:	8d 48 01             	lea    0x1(%eax),%ecx
80103773:	25 ff 01 00 00       	and    $0x1ff,%eax
80103778:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010377e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103783:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103786:	83 c3 01             	add    $0x1,%ebx
80103789:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010378c:	74 0e                	je     8010379c <piperead+0xac>
    if(p->nread == p->nwrite)
8010378e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103794:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010379a:	75 d4                	jne    80103770 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010379c:	83 ec 0c             	sub    $0xc,%esp
8010379f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037a5:	50                   	push   %eax
801037a6:	e8 85 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801037ab:	89 34 24             	mov    %esi,(%esp)
801037ae:	e8 8d 0e 00 00       	call   80104640 <release>
  return i;
801037b3:	83 c4 10             	add    $0x10,%esp
}
801037b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b9:	89 d8                	mov    %ebx,%eax
801037bb:	5b                   	pop    %ebx
801037bc:	5e                   	pop    %esi
801037bd:	5f                   	pop    %edi
801037be:	5d                   	pop    %ebp
801037bf:	c3                   	ret    
      release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037c8:	56                   	push   %esi
801037c9:	e8 72 0e 00 00       	call   80104640 <release>
      return -1;
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	89 d8                	mov    %ebx,%eax
801037d6:	5b                   	pop    %ebx
801037d7:	5e                   	pop    %esi
801037d8:	5f                   	pop    %edi
801037d9:	5d                   	pop    %ebp
801037da:	c3                   	ret    
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ec:	68 20 2d 11 80       	push   $0x80112d20
801037f1:	e8 1a 0d 00 00       	call   80104510 <acquire>
801037f6:	83 c4 10             	add    $0x10,%esp
801037f9:	eb 10                	jmp    8010380b <allocproc+0x2b>
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	83 eb 80             	sub    $0xffffff80,%ebx
80103803:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103809:	74 75                	je     80103880 <allocproc+0xa0>
    if(p->state == UNUSED)
8010380b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010380e:	85 c0                	test   %eax,%eax
80103810:	75 ee                	jne    80103800 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103812:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103817:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010381a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103821:	89 43 10             	mov    %eax,0x10(%ebx)
80103824:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103827:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010382c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103832:	e8 09 0e 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103837:	e8 34 ee ff ff       	call   80102670 <kalloc>
8010383c:	83 c4 10             	add    $0x10,%esp
8010383f:	89 43 08             	mov    %eax,0x8(%ebx)
80103842:	85 c0                	test   %eax,%eax
80103844:	74 53                	je     80103899 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103846:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010384f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103854:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103857:	c7 40 14 d6 58 10 80 	movl   $0x801058d6,0x14(%eax)
  p->context = (struct context*)sp;
8010385e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103861:	6a 14                	push   $0x14
80103863:	6a 00                	push   $0x0
80103865:	50                   	push   %eax
80103866:	e8 25 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
8010386b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103871:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103878:	89 d8                	mov    %ebx,%eax
8010387a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387d:	c9                   	leave  
8010387e:	c3                   	ret    
8010387f:	90                   	nop
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 2d 11 80       	push   $0x80112d20
8010388a:	e8 b1 0d 00 00       	call   80104640 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ba:	68 20 2d 11 80       	push   $0x80112d20
801038bf:	e8 7c 0d 00 00       	call   80104640 <release>

  if (first) {
801038c4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	85 c0                	test   %eax,%eax
801038ce:	75 08                	jne    801038d8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038d0:	c9                   	leave  
801038d1:	c3                   	ret    
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038d8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038df:	00 00 00 
    iinit(ROOTDEV);
801038e2:	83 ec 0c             	sub    $0xc,%esp
801038e5:	6a 01                	push   $0x1
801038e7:	e8 94 dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038f3:	e8 d8 f3 ff ff       	call   80102cd0 <initlog>
}
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	c9                   	leave  
801038fc:	c3                   	ret    
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <pinit>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010390a:	68 60 78 10 80       	push   $0x80107860
8010390f:	68 20 2d 11 80       	push   $0x80112d20
80103914:	e8 e7 0a 00 00       	call   80104400 <initlock>
}
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax

80103920 <mycpu>:
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	56                   	push   %esi
80103928:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103929:	9c                   	pushf  
8010392a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010392b:	f6 c4 02             	test   $0x2,%ah
8010392e:	75 4a                	jne    8010397a <mycpu+0x5a>
  apicid = lapicid();
80103930:	e8 ab ef ff ff       	call   801028e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103935:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010393b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010393d:	85 f6                	test   %esi,%esi
8010393f:	7e 2c                	jle    8010396d <mycpu+0x4d>
80103941:	31 d2                	xor    %edx,%edx
80103943:	eb 0a                	jmp    8010394f <mycpu+0x2f>
80103945:	8d 76 00             	lea    0x0(%esi),%esi
80103948:	83 c2 01             	add    $0x1,%edx
8010394b:	39 f2                	cmp    %esi,%edx
8010394d:	74 1e                	je     8010396d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010394f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103955:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010395c:	39 d8                	cmp    %ebx,%eax
8010395e:	75 e8                	jne    80103948 <mycpu+0x28>
}
80103960:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103963:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5d                   	pop    %ebp
8010396c:	c3                   	ret    
  panic("unknown apicid\n");
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 67 78 10 80       	push   $0x80107867
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 44 79 10 80       	push   $0x80107944
80103982:	e8 09 ca ff ff       	call   80100390 <panic>
80103987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398e:	66 90                	xchg   %ax,%ax

80103990 <cpuid>:
cpuid() {
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010399a:	e8 81 ff ff ff       	call   80103920 <mycpu>
}
8010399f:	c9                   	leave  
  return mycpu()-cpus;
801039a0:	2d 80 27 11 80       	sub    $0x80112780,%eax
801039a5:	c1 f8 04             	sar    $0x4,%eax
801039a8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ae:	c3                   	ret    
801039af:	90                   	nop

801039b0 <myproc>:
myproc(void) {
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039bb:	e8 00 0b 00 00       	call   801044c0 <pushcli>
  c = mycpu();
801039c0:	e8 5b ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039c5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039cb:	e8 10 0c 00 00       	call   801045e0 <popcli>
}
801039d0:	83 c4 04             	add    $0x4,%esp
801039d3:	89 d8                	mov    %ebx,%eax
801039d5:	5b                   	pop    %ebx
801039d6:	5d                   	pop    %ebp
801039d7:	c3                   	ret    
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <userinit>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039eb:	e8 f0 fd ff ff       	call   801037e0 <allocproc>
801039f0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039f2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039f7:	e8 54 35 00 00       	call   80106f50 <setupkvm>
801039fc:	89 43 04             	mov    %eax,0x4(%ebx)
801039ff:	85 c0                	test   %eax,%eax
80103a01:	0f 84 bd 00 00 00    	je     80103ac4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a07:	83 ec 04             	sub    $0x4,%esp
80103a0a:	68 2c 00 00 00       	push   $0x2c
80103a0f:	68 60 a4 10 80       	push   $0x8010a460
80103a14:	50                   	push   %eax
80103a15:	e8 b6 31 00 00       	call   80106bd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a23:	6a 4c                	push   $0x4c
80103a25:	6a 00                	push   $0x0
80103a27:	ff 73 18             	pushl  0x18(%ebx)
80103a2a:	e8 61 0c 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a43:	8b 43 18             	mov    0x18(%ebx),%eax
80103a46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a55:	8b 43 18             	mov    0x18(%ebx),%eax
80103a58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a74:	8b 43 18             	mov    0x18(%ebx),%eax
80103a77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a81:	6a 10                	push   $0x10
80103a83:	68 90 78 10 80       	push   $0x80107890
80103a88:	50                   	push   %eax
80103a89:	e8 c2 0d 00 00       	call   80104850 <safestrcpy>
  p->cwd = namei("/");
80103a8e:	c7 04 24 99 78 10 80 	movl   $0x80107899,(%esp)
80103a95:	e8 d6 e5 ff ff       	call   80102070 <namei>
80103a9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a9d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aa4:	e8 67 0a 00 00       	call   80104510 <acquire>
  p->state = RUNNABLE;
80103aa9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ab0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ab7:	e8 84 0b 00 00       	call   80104640 <release>
}
80103abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	c9                   	leave  
80103ac3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac4:	83 ec 0c             	sub    $0xc,%esp
80103ac7:	68 77 78 10 80       	push   $0x80107877
80103acc:	e8 bf c8 ff ff       	call   80100390 <panic>
80103ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <growproc>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
80103ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aec:	e8 cf 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103af1:	e8 2a fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103af6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103afc:	e8 df 0a 00 00       	call   801045e0 <popcli>
  sz = curproc->sz;
80103b01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b03:	85 f6                	test   %esi,%esi
80103b05:	7f 19                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b07:	75 37                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0e:	53                   	push   %ebx
80103b0f:	e8 ac 2f 00 00       	call   80106ac0 <switchuvm>
  return 0;
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	31 c0                	xor    %eax,%eax
}
80103b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 f1 31 00 00       	call   80106d20 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 d3                	jne    80103b09 <growproc+0x29>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb dc                	jmp    80103b19 <growproc+0x39>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	pushl  0x4(%ebx)
80103b4a:	e8 51 33 00 00       	call   80106ea0 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 b3                	jne    80103b09 <growproc+0x29>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <fork>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	57                   	push   %edi
80103b68:	56                   	push   %esi
80103b69:	53                   	push   %ebx
80103b6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b6d:	e8 4e 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b72:	e8 a9 fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b7d:	e8 5e 0a 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103b82:	e8 59 fc ff ff       	call   801037e0 <allocproc>
80103b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	0f 84 bb 00 00 00    	je     80103c4d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	ff 33                	pushl  (%ebx)
80103b97:	89 c7                	mov    %eax,%edi
80103b99:	ff 73 04             	pushl  0x4(%ebx)
80103b9c:	e8 7f 34 00 00       	call   80107020 <copyuvm>
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	89 47 04             	mov    %eax,0x4(%edi)
80103ba7:	85 c0                	test   %eax,%eax
80103ba9:	0f 84 a5 00 00 00    	je     80103c54 <fork+0xf4>
  np->sz = curproc->sz;
80103baf:	8b 03                	mov    (%ebx),%eax
80103bb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bb6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bb9:	89 c8                	mov    %ecx,%eax
80103bbb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bbe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bc3:	8b 73 18             	mov    0x18(%ebx),%esi
80103bc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bc8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bca:	8b 40 18             	mov    0x18(%eax),%eax
80103bcd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103bd8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bdc:	85 c0                	test   %eax,%eax
80103bde:	74 13                	je     80103bf3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	50                   	push   %eax
80103be4:	e8 c7 d2 ff ff       	call   80100eb0 <filedup>
80103be9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bec:	83 c4 10             	add    $0x10,%esp
80103bef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bf3:	83 c6 01             	add    $0x1,%esi
80103bf6:	83 fe 10             	cmp    $0x10,%esi
80103bf9:	75 dd                	jne    80103bd8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bfb:	83 ec 0c             	sub    $0xc,%esp
80103bfe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c01:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c04:	e8 67 db ff ff       	call   80101770 <idup>
80103c09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c0c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c0f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c12:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c15:	6a 10                	push   $0x10
80103c17:	53                   	push   %ebx
80103c18:	50                   	push   %eax
80103c19:	e8 32 0c 00 00       	call   80104850 <safestrcpy>
  pid = np->pid;
80103c1e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c21:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c28:	e8 e3 08 00 00       	call   80104510 <acquire>
  np->state = RUNNABLE;
80103c2d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c34:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c3b:	e8 00 0a 00 00       	call   80104640 <release>
  return pid;
80103c40:	83 c4 10             	add    $0x10,%esp
}
80103c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c46:	89 d8                	mov    %ebx,%eax
80103c48:	5b                   	pop    %ebx
80103c49:	5e                   	pop    %esi
80103c4a:	5f                   	pop    %edi
80103c4b:	5d                   	pop    %ebp
80103c4c:	c3                   	ret    
    return -1;
80103c4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c52:	eb ef                	jmp    80103c43 <fork+0xe3>
    kfree(np->kstack);
80103c54:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	ff 73 08             	pushl  0x8(%ebx)
80103c5d:	e8 4e e8 ff ff       	call   801024b0 <kfree>
    np->kstack = 0;
80103c62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c69:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c78:	eb c9                	jmp    80103c43 <fork+0xe3>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c80 <scheduler>:
{
80103c80:	f3 0f 1e fb          	endbr32 
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	57                   	push   %edi
80103c88:	56                   	push   %esi
80103c89:	53                   	push   %ebx
80103c8a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c8d:	e8 8e fc ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103c92:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c99:	00 00 00 
  struct cpu *c = mycpu();
80103c9c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c9e:	8d 78 04             	lea    0x4(%eax),%edi
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103ca8:	fb                   	sti    
    acquire(&ptable.lock);
80103ca9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cac:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103cb1:	68 20 2d 11 80       	push   $0x80112d20
80103cb6:	e8 55 08 00 00       	call   80104510 <acquire>
80103cbb:	83 c4 10             	add    $0x10,%esp
80103cbe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103cc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cc4:	75 33                	jne    80103cf9 <scheduler+0x79>
      switchuvm(p);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ccf:	53                   	push   %ebx
80103cd0:	e8 eb 2d 00 00       	call   80106ac0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cd5:	58                   	pop    %eax
80103cd6:	5a                   	pop    %edx
80103cd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103cda:	57                   	push   %edi
      p->state = RUNNING;
80103cdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ce2:	e8 cc 0b 00 00       	call   801048b3 <swtch>
      switchkvm();
80103ce7:	e8 b4 2d 00 00       	call   80106aa0 <switchkvm>
      c->proc = 0;
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	83 eb 80             	sub    $0xffffff80,%ebx
80103cfc:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d02:	75 bc                	jne    80103cc0 <scheduler+0x40>
    release(&ptable.lock);
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	68 20 2d 11 80       	push   $0x80112d20
80103d0c:	e8 2f 09 00 00       	call   80104640 <release>
    sti();
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	eb 92                	jmp    80103ca8 <scheduler+0x28>
80103d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <sched>:
{
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	56                   	push   %esi
80103d28:	53                   	push   %ebx
  pushcli();
80103d29:	e8 92 07 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103d2e:	e8 ed fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d39:	e8 a2 08 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103d3e:	83 ec 0c             	sub    $0xc,%esp
80103d41:	68 20 2d 11 80       	push   $0x80112d20
80103d46:	e8 35 07 00 00       	call   80104480 <holding>
80103d4b:	83 c4 10             	add    $0x10,%esp
80103d4e:	85 c0                	test   %eax,%eax
80103d50:	74 4f                	je     80103da1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d52:	e8 c9 fb ff ff       	call   80103920 <mycpu>
80103d57:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5e:	75 68                	jne    80103dc8 <sched+0xa8>
  if(p->state == RUNNING)
80103d60:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d64:	74 55                	je     80103dbb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d66:	9c                   	pushf  
80103d67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d68:	f6 c4 02             	test   $0x2,%ah
80103d6b:	75 41                	jne    80103dae <sched+0x8e>
  intena = mycpu()->intena;
80103d6d:	e8 ae fb ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d72:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d75:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d7b:	e8 a0 fb ff ff       	call   80103920 <mycpu>
80103d80:	83 ec 08             	sub    $0x8,%esp
80103d83:	ff 70 04             	pushl  0x4(%eax)
80103d86:	53                   	push   %ebx
80103d87:	e8 27 0b 00 00       	call   801048b3 <swtch>
  mycpu()->intena = intena;
80103d8c:	e8 8f fb ff ff       	call   80103920 <mycpu>
}
80103d91:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d94:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d9d:	5b                   	pop    %ebx
80103d9e:	5e                   	pop    %esi
80103d9f:	5d                   	pop    %ebp
80103da0:	c3                   	ret    
    panic("sched ptable.lock");
80103da1:	83 ec 0c             	sub    $0xc,%esp
80103da4:	68 9b 78 10 80       	push   $0x8010789b
80103da9:	e8 e2 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dae:	83 ec 0c             	sub    $0xc,%esp
80103db1:	68 c7 78 10 80       	push   $0x801078c7
80103db6:	e8 d5 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103dbb:	83 ec 0c             	sub    $0xc,%esp
80103dbe:	68 b9 78 10 80       	push   $0x801078b9
80103dc3:	e8 c8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	68 ad 78 10 80       	push   $0x801078ad
80103dd0:	e8 bb c5 ff ff       	call   80100390 <panic>
80103dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103de0 <exit>:
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	57                   	push   %edi
80103de8:	56                   	push   %esi
80103de9:	53                   	push   %ebx
80103dea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ded:	e8 ce 06 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103df2:	e8 29 fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103df7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dfd:	e8 de 07 00 00       	call   801045e0 <popcli>
  if(curproc == initproc)
80103e02:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e05:	8d 7e 68             	lea    0x68(%esi),%edi
80103e08:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e0e:	0f 84 f3 00 00 00    	je     80103f07 <exit+0x127>
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e18:	8b 03                	mov    (%ebx),%eax
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 12                	je     80103e30 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	50                   	push   %eax
80103e22:	e8 d9 d0 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103e27:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e30:	83 c3 04             	add    $0x4,%ebx
80103e33:	39 df                	cmp    %ebx,%edi
80103e35:	75 e1                	jne    80103e18 <exit+0x38>
  begin_op();
80103e37:	e8 34 ef ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	ff 76 68             	pushl  0x68(%esi)
80103e42:	e8 89 da ff ff       	call   801018d0 <iput>
  end_op();
80103e47:	e8 94 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103e4c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e5a:	e8 b1 06 00 00       	call   80104510 <acquire>
  wakeup1(curproc->parent);
80103e5f:	8b 56 14             	mov    0x14(%esi),%edx
80103e62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e65:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6a:	eb 0e                	jmp    80103e7a <exit+0x9a>
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e70:	83 e8 80             	sub    $0xffffff80,%eax
80103e73:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e78:	74 1c                	je     80103e96 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <exit+0x90>
80103e80:	3b 50 20             	cmp    0x20(%eax),%edx
80103e83:	75 eb                	jne    80103e70 <exit+0x90>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	83 e8 80             	sub    $0xffffff80,%eax
80103e8f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e94:	75 e4                	jne    80103e7a <exit+0x9a>
      p->parent = initproc;
80103e96:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e9c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ea1:	eb 10                	jmp    80103eb3 <exit+0xd3>
80103ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea7:	90                   	nop
80103ea8:	83 ea 80             	sub    $0xffffff80,%edx
80103eab:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103eb1:	74 3b                	je     80103eee <exit+0x10e>
    if(p->parent == curproc){
80103eb3:	39 72 14             	cmp    %esi,0x14(%edx)
80103eb6:	75 f0                	jne    80103ea8 <exit+0xc8>
      if(p->state == ZOMBIE)
80103eb8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ebc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ebf:	75 e7                	jne    80103ea8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ec6:	eb 12                	jmp    80103eda <exit+0xfa>
80103ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop
80103ed0:	83 e8 80             	sub    $0xffffff80,%eax
80103ed3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ed8:	74 ce                	je     80103ea8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <exit+0xf0>
80103ee0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ee3:	75 eb                	jne    80103ed0 <exit+0xf0>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eec:	eb e2                	jmp    80103ed0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103eee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ef5:	e8 26 fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 e8 78 10 80       	push   $0x801078e8
80103f02:	e8 89 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	68 db 78 10 80       	push   $0x801078db
80103f0f:	e8 7c c4 ff ff       	call   80100390 <panic>
80103f14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f1f:	90                   	nop

80103f20 <yield>:
{
80103f20:	f3 0f 1e fb          	endbr32 
80103f24:	55                   	push   %ebp
80103f25:	89 e5                	mov    %esp,%ebp
80103f27:	53                   	push   %ebx
80103f28:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f2b:	68 20 2d 11 80       	push   $0x80112d20
80103f30:	e8 db 05 00 00       	call   80104510 <acquire>
  pushcli();
80103f35:	e8 86 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f3a:	e8 e1 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f45:	e8 96 06 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80103f4a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f51:	e8 ca fd ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80103f56:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f5d:	e8 de 06 00 00       	call   80104640 <release>
}
80103f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	c9                   	leave  
80103f69:	c3                   	ret    
80103f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f70 <sleep>:
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	57                   	push   %edi
80103f78:	56                   	push   %esi
80103f79:	53                   	push   %ebx
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f80:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f83:	e8 38 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f88:	e8 93 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f8d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f93:	e8 48 06 00 00       	call   801045e0 <popcli>
  if(p == 0)
80103f98:	85 db                	test   %ebx,%ebx
80103f9a:	0f 84 83 00 00 00    	je     80104023 <sleep+0xb3>
  if(lk == 0)
80103fa0:	85 f6                	test   %esi,%esi
80103fa2:	74 72                	je     80104016 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fa4:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103faa:	74 4c                	je     80103ff8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 20 2d 11 80       	push   $0x80112d20
80103fb4:	e8 57 05 00 00       	call   80104510 <acquire>
    release(lk);
80103fb9:	89 34 24             	mov    %esi,(%esp)
80103fbc:	e8 7f 06 00 00       	call   80104640 <release>
  p->chan = chan;
80103fc1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fc4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fcb:	e8 50 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103fd0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fd7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fde:	e8 5d 06 00 00       	call   80104640 <release>
    acquire(lk);
80103fe3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fe6:	83 c4 10             	add    $0x10,%esp
}
80103fe9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fec:	5b                   	pop    %ebx
80103fed:	5e                   	pop    %esi
80103fee:	5f                   	pop    %edi
80103fef:	5d                   	pop    %ebp
    acquire(lk);
80103ff0:	e9 1b 05 00 00       	jmp    80104510 <acquire>
80103ff5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103ff8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ffb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104002:	e8 19 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104007:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010400e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104011:	5b                   	pop    %ebx
80104012:	5e                   	pop    %esi
80104013:	5f                   	pop    %edi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
    panic("sleep without lk");
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 fa 78 10 80       	push   $0x801078fa
8010401e:	e8 6d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	68 f4 78 10 80       	push   $0x801078f4
8010402b:	e8 60 c3 ff ff       	call   80100390 <panic>

80104030 <wait>:
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	56                   	push   %esi
80104038:	53                   	push   %ebx
  pushcli();
80104039:	e8 82 04 00 00       	call   801044c0 <pushcli>
  c = mycpu();
8010403e:	e8 dd f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104043:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104049:	e8 92 05 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010404e:	83 ec 0c             	sub    $0xc,%esp
80104051:	68 20 2d 11 80       	push   $0x80112d20
80104056:	e8 b5 04 00 00       	call   80104510 <acquire>
8010405b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010405e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104060:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104065:	eb 14                	jmp    8010407b <wait+0x4b>
80104067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406e:	66 90                	xchg   %ax,%ax
80104070:	83 eb 80             	sub    $0xffffff80,%ebx
80104073:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104079:	74 1b                	je     80104096 <wait+0x66>
      if(p->parent != curproc)
8010407b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010407e:	75 f0                	jne    80104070 <wait+0x40>
      if(p->state == ZOMBIE){
80104080:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104084:	74 32                	je     801040b8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104086:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104089:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104094:	75 e5                	jne    8010407b <wait+0x4b>
    if(!havekids || curproc->killed){
80104096:	85 c0                	test   %eax,%eax
80104098:	74 74                	je     8010410e <wait+0xde>
8010409a:	8b 46 24             	mov    0x24(%esi),%eax
8010409d:	85 c0                	test   %eax,%eax
8010409f:	75 6d                	jne    8010410e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040a1:	83 ec 08             	sub    $0x8,%esp
801040a4:	68 20 2d 11 80       	push   $0x80112d20
801040a9:	56                   	push   %esi
801040aa:	e8 c1 fe ff ff       	call   80103f70 <sleep>
    havekids = 0;
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	eb aa                	jmp    8010405e <wait+0x2e>
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040be:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c1:	e8 ea e3 ff ff       	call   801024b0 <kfree>
        freevm(p->pgdir);
801040c6:	5a                   	pop    %edx
801040c7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040ca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040d1:	e8 fa 2d 00 00       	call   80106ed0 <freevm>
        release(&ptable.lock);
801040d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040dd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040e4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040eb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040ef:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040fd:	e8 3e 05 00 00       	call   80104640 <release>
        return pid;
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104108:	89 f0                	mov    %esi,%eax
8010410a:	5b                   	pop    %ebx
8010410b:	5e                   	pop    %esi
8010410c:	5d                   	pop    %ebp
8010410d:	c3                   	ret    
      release(&ptable.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104111:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104116:	68 20 2d 11 80       	push   $0x80112d20
8010411b:	e8 20 05 00 00       	call   80104640 <release>
      return -1;
80104120:	83 c4 10             	add    $0x10,%esp
80104123:	eb e0                	jmp    80104105 <wait+0xd5>
80104125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	53                   	push   %ebx
80104138:	83 ec 10             	sub    $0x10,%esp
8010413b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413e:	68 20 2d 11 80       	push   $0x80112d20
80104143:	e8 c8 03 00 00       	call   80104510 <acquire>
80104148:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104150:	eb 10                	jmp    80104162 <wakeup+0x32>
80104152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104158:	83 e8 80             	sub    $0xffffff80,%eax
8010415b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104160:	74 1c                	je     8010417e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104162:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104166:	75 f0                	jne    80104158 <wakeup+0x28>
80104168:	3b 58 20             	cmp    0x20(%eax),%ebx
8010416b:	75 eb                	jne    80104158 <wakeup+0x28>
      p->state = RUNNABLE;
8010416d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104174:	83 e8 80             	sub    $0xffffff80,%eax
80104177:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010417c:	75 e4                	jne    80104162 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010417e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104188:	c9                   	leave  
  release(&ptable.lock);
80104189:	e9 b2 04 00 00       	jmp    80104640 <release>
8010418e:	66 90                	xchg   %ax,%ax

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	f3 0f 1e fb          	endbr32 
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	53                   	push   %ebx
80104198:	83 ec 10             	sub    $0x10,%esp
8010419b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419e:	68 20 2d 11 80       	push   $0x80112d20
801041a3:	e8 68 03 00 00       	call   80104510 <acquire>
801041a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ab:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041b0:	eb 10                	jmp    801041c2 <kill+0x32>
801041b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041b8:	83 e8 80             	sub    $0xffffff80,%eax
801041bb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801041c0:	74 36                	je     801041f8 <kill+0x68>
    if(p->pid == pid){
801041c2:	39 58 10             	cmp    %ebx,0x10(%eax)
801041c5:	75 f1                	jne    801041b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041c7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041d2:	75 07                	jne    801041db <kill+0x4b>
        p->state = RUNNABLE;
801041d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041db:	83 ec 0c             	sub    $0xc,%esp
801041de:	68 20 2d 11 80       	push   $0x80112d20
801041e3:	e8 58 04 00 00       	call   80104640 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	31 c0                	xor    %eax,%eax
}
801041f0:	c9                   	leave  
801041f1:	c3                   	ret    
801041f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 20 2d 11 80       	push   $0x80112d20
80104200:	e8 3b 04 00 00       	call   80104640 <release>
}
80104205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104210:	c9                   	leave  
80104211:	c3                   	ret    
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	57                   	push   %edi
80104228:	56                   	push   %esi
80104229:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010422c:	53                   	push   %ebx
8010422d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104232:	83 ec 3c             	sub    $0x3c,%esp
80104235:	eb 28                	jmp    8010425f <procdump+0x3f>
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	68 30 7d 10 80       	push   $0x80107d30
80104248:	e8 63 c4 ff ff       	call   801006b0 <cprintf>
8010424d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104250:	83 eb 80             	sub    $0xffffff80,%ebx
80104253:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104259:	0f 84 81 00 00 00    	je     801042e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010425f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104262:	85 c0                	test   %eax,%eax
80104264:	74 ea                	je     80104250 <procdump+0x30>
      state = "???";
80104266:	ba 0b 79 10 80       	mov    $0x8010790b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010426b:	83 f8 05             	cmp    $0x5,%eax
8010426e:	77 11                	ja     80104281 <procdump+0x61>
80104270:	8b 14 85 6c 79 10 80 	mov    -0x7fef8694(,%eax,4),%edx
      state = "???";
80104277:	b8 0b 79 10 80       	mov    $0x8010790b,%eax
8010427c:	85 d2                	test   %edx,%edx
8010427e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104281:	53                   	push   %ebx
80104282:	52                   	push   %edx
80104283:	ff 73 a4             	pushl  -0x5c(%ebx)
80104286:	68 0f 79 10 80       	push   $0x8010790f
8010428b:	e8 20 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104290:	83 c4 10             	add    $0x10,%esp
80104293:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104297:	75 a7                	jne    80104240 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104299:	83 ec 08             	sub    $0x8,%esp
8010429c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010429f:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042a2:	50                   	push   %eax
801042a3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042a6:	8b 40 0c             	mov    0xc(%eax),%eax
801042a9:	83 c0 08             	add    $0x8,%eax
801042ac:	50                   	push   %eax
801042ad:	e8 6e 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b2:	83 c4 10             	add    $0x10,%esp
801042b5:	8d 76 00             	lea    0x0(%esi),%esi
801042b8:	8b 17                	mov    (%edi),%edx
801042ba:	85 d2                	test   %edx,%edx
801042bc:	74 82                	je     80104240 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042be:	83 ec 08             	sub    $0x8,%esp
801042c1:	83 c7 04             	add    $0x4,%edi
801042c4:	52                   	push   %edx
801042c5:	68 61 73 10 80       	push   $0x80107361
801042ca:	e8 e1 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	39 fe                	cmp    %edi,%esi
801042d4:	75 e2                	jne    801042b8 <procdump+0x98>
801042d6:	e9 65 ff ff ff       	jmp    80104240 <procdump+0x20>
801042db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042df:	90                   	nop
  }
}
801042e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e3:	5b                   	pop    %ebx
801042e4:	5e                   	pop    %esi
801042e5:	5f                   	pop    %edi
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    
801042e8:	66 90                	xchg   %ax,%ax
801042ea:	66 90                	xchg   %ax,%ax
801042ec:	66 90                	xchg   %ax,%ax
801042ee:	66 90                	xchg   %ax,%ax

801042f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	53                   	push   %ebx
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042fe:	68 84 79 10 80       	push   $0x80107984
80104303:	8d 43 04             	lea    0x4(%ebx),%eax
80104306:	50                   	push   %eax
80104307:	e8 f4 00 00 00       	call   80104400 <initlock>
  lk->name = name;
8010430c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010430f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104315:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104318:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010431f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104325:	c9                   	leave  
80104326:	c3                   	ret    
80104327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432e:	66 90                	xchg   %ax,%ax

80104330 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
80104339:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010433c:	8d 73 04             	lea    0x4(%ebx),%esi
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	56                   	push   %esi
80104343:	e8 c8 01 00 00       	call   80104510 <acquire>
  while (lk->locked) {
80104348:	8b 13                	mov    (%ebx),%edx
8010434a:	83 c4 10             	add    $0x10,%esp
8010434d:	85 d2                	test   %edx,%edx
8010434f:	74 1a                	je     8010436b <acquiresleep+0x3b>
80104351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	56                   	push   %esi
8010435c:	53                   	push   %ebx
8010435d:	e8 0e fc ff ff       	call   80103f70 <sleep>
  while (lk->locked) {
80104362:	8b 03                	mov    (%ebx),%eax
80104364:	83 c4 10             	add    $0x10,%esp
80104367:	85 c0                	test   %eax,%eax
80104369:	75 ed                	jne    80104358 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010436b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104371:	e8 3a f6 ff ff       	call   801039b0 <myproc>
80104376:	8b 40 10             	mov    0x10(%eax),%eax
80104379:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010437c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010437f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
  release(&lk->lk);
80104385:	e9 b6 02 00 00       	jmp    80104640 <release>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	56                   	push   %esi
80104398:	53                   	push   %ebx
80104399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010439c:	8d 73 04             	lea    0x4(%ebx),%esi
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	56                   	push   %esi
801043a3:	e8 68 01 00 00       	call   80104510 <acquire>
  lk->locked = 0;
801043a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043b5:	89 1c 24             	mov    %ebx,(%esp)
801043b8:	e8 73 fd ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
801043bd:	89 75 08             	mov    %esi,0x8(%ebp)
801043c0:	83 c4 10             	add    $0x10,%esp
}
801043c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c6:	5b                   	pop    %ebx
801043c7:	5e                   	pop    %esi
801043c8:	5d                   	pop    %ebp
  release(&lk->lk);
801043c9:	e9 72 02 00 00       	jmp    80104640 <release>
801043ce:	66 90                	xchg   %ax,%ax

801043d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	56                   	push   %esi
801043d8:	53                   	push   %ebx
801043d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801043dc:	8d 5e 04             	lea    0x4(%esi),%ebx
801043df:	83 ec 0c             	sub    $0xc,%esp
801043e2:	53                   	push   %ebx
801043e3:	e8 28 01 00 00       	call   80104510 <acquire>
  r = lk->locked;
801043e8:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801043ea:	89 1c 24             	mov    %ebx,(%esp)
801043ed:	e8 4e 02 00 00       	call   80104640 <release>
  return r;
}
801043f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043f5:	89 f0                	mov    %esi,%eax
801043f7:	5b                   	pop    %ebx
801043f8:	5e                   	pop    %esi
801043f9:	5d                   	pop    %ebp
801043fa:	c3                   	ret    
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010440a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010440d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104413:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104416:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010441d:	5d                   	pop    %ebp
8010441e:	c3                   	ret    
8010441f:	90                   	nop

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104425:	31 d2                	xor    %edx,%edx
{
80104427:	89 e5                	mov    %esp,%ebp
80104429:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010442a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010442d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104430:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104438:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010443e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104444:	77 1a                	ja     80104460 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104446:	8b 58 04             	mov    0x4(%eax),%ebx
80104449:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010444c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010444f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104451:	83 fa 0a             	cmp    $0xa,%edx
80104454:	75 e2                	jne    80104438 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104456:	5b                   	pop    %ebx
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104460:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104463:	8d 51 28             	lea    0x28(%ecx),%edx
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104476:	83 c0 04             	add    $0x4,%eax
80104479:	39 d0                	cmp    %edx,%eax
8010447b:	75 f3                	jne    80104470 <getcallerpcs+0x50>
}
8010447d:	5b                   	pop    %ebx
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 04             	sub    $0x4,%esp
8010448b:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010448e:	8b 02                	mov    (%edx),%eax
80104490:	85 c0                	test   %eax,%eax
80104492:	75 0c                	jne    801044a0 <holding+0x20>
}
80104494:	83 c4 04             	add    $0x4,%esp
80104497:	31 c0                	xor    %eax,%eax
80104499:	5b                   	pop    %ebx
8010449a:	5d                   	pop    %ebp
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801044a0:	8b 5a 08             	mov    0x8(%edx),%ebx
801044a3:	e8 78 f4 ff ff       	call   80103920 <mycpu>
801044a8:	39 c3                	cmp    %eax,%ebx
801044aa:	0f 94 c0             	sete   %al
}
801044ad:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801044b0:	0f b6 c0             	movzbl %al,%eax
}
801044b3:	5b                   	pop    %ebx
801044b4:	5d                   	pop    %ebp
801044b5:	c3                   	ret    
801044b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	83 ec 04             	sub    $0x4,%esp
801044cb:	9c                   	pushf  
801044cc:	5b                   	pop    %ebx
  asm volatile("cli");
801044cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ce:	e8 4d f4 ff ff       	call   80103920 <mycpu>
801044d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044d9:	85 c0                	test   %eax,%eax
801044db:	74 13                	je     801044f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044dd:	e8 3e f4 ff ff       	call   80103920 <mycpu>
801044e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044e9:	83 c4 04             	add    $0x4,%esp
801044ec:	5b                   	pop    %ebx
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044f0:	e8 2b f4 ff ff       	call   80103920 <mycpu>
801044f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104501:	eb da                	jmp    801044dd <pushcli+0x1d>
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <acquire>:
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104519:	e8 a2 ff ff ff       	call   801044c0 <pushcli>
  if(holding(lk))
8010451e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104521:	8b 03                	mov    (%ebx),%eax
80104523:	85 c0                	test   %eax,%eax
80104525:	0f 85 8d 00 00 00    	jne    801045b8 <acquire+0xa8>
  asm volatile("lock; xchgl %0, %1" :
8010452b:	ba 01 00 00 00       	mov    $0x1,%edx
80104530:	eb 09                	jmp    8010453b <acquire+0x2b>
80104532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104538:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010453b:	89 d0                	mov    %edx,%eax
8010453d:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104540:	85 c0                	test   %eax,%eax
80104542:	75 f4                	jne    80104538 <acquire+0x28>
  __sync_synchronize();
80104544:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010454c:	e8 cf f3 ff ff       	call   80103920 <mycpu>
  ebp = (uint*)v - 2;
80104551:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104553:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104556:	31 c0                	xor    %eax,%eax
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104560:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104566:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010456c:	77 22                	ja     80104590 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010456e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104571:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104575:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104578:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010457a:	83 f8 0a             	cmp    $0xa,%eax
8010457d:	75 e1                	jne    80104560 <acquire+0x50>
}
8010457f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104590:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104594:	83 c3 34             	add    $0x34,%ebx
80104597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045a6:	83 c0 04             	add    $0x4,%eax
801045a9:	39 d8                	cmp    %ebx,%eax
801045ab:	75 f3                	jne    801045a0 <acquire+0x90>
}
801045ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b0:	5b                   	pop    %ebx
801045b1:	5e                   	pop    %esi
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801045b8:	8b 73 08             	mov    0x8(%ebx),%esi
801045bb:	e8 60 f3 ff ff       	call   80103920 <mycpu>
801045c0:	39 c6                	cmp    %eax,%esi
801045c2:	0f 85 63 ff ff ff    	jne    8010452b <acquire+0x1b>
    panic("acquire");
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 8f 79 10 80       	push   $0x8010798f
801045d0:	e8 bb bd ff ff       	call   80100390 <panic>
801045d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045ea:	9c                   	pushf  
801045eb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045ec:	f6 c4 02             	test   $0x2,%ah
801045ef:	75 31                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045f1:	e8 2a f3 ff ff       	call   80103920 <mycpu>
801045f6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045fd:	78 30                	js     8010462f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045ff:	e8 1c f3 ff ff       	call   80103920 <mycpu>
80104604:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010460a:	85 d2                	test   %edx,%edx
8010460c:	74 02                	je     80104610 <popcli+0x30>
    sti();
}
8010460e:	c9                   	leave  
8010460f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 0b f3 ff ff       	call   80103920 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 ef                	je     8010460e <popcli+0x2e>
  asm volatile("sti");
8010461f:	fb                   	sti    
}
80104620:	c9                   	leave  
80104621:	c3                   	ret    
    panic("popcli - interruptible");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 97 79 10 80       	push   $0x80107997
8010462a:	e8 61 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	68 ae 79 10 80       	push   $0x801079ae
80104637:	e8 54 bd ff ff       	call   80100390 <panic>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <release>:
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	56                   	push   %esi
80104648:	53                   	push   %ebx
80104649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010464c:	8b 03                	mov    (%ebx),%eax
8010464e:	85 c0                	test   %eax,%eax
80104650:	75 0e                	jne    80104660 <release+0x20>
    panic("release");
80104652:	83 ec 0c             	sub    $0xc,%esp
80104655:	68 b5 79 10 80       	push   $0x801079b5
8010465a:	e8 31 bd ff ff       	call   80100390 <panic>
8010465f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104660:	8b 73 08             	mov    0x8(%ebx),%esi
80104663:	e8 b8 f2 ff ff       	call   80103920 <mycpu>
80104668:	39 c6                	cmp    %eax,%esi
8010466a:	75 e6                	jne    80104652 <release+0x12>
  lk->pcs[0] = 0;
8010466c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104673:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010467a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010467f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104685:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5d                   	pop    %ebp
  popcli();
8010468b:	e9 50 ff ff ff       	jmp    801045e0 <popcli>

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	57                   	push   %edi
80104698:	8b 55 08             	mov    0x8(%ebp),%edx
8010469b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469e:	53                   	push   %ebx
8010469f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	09 cf                	or     %ecx,%edi
801046a6:	83 e7 03             	and    $0x3,%edi
801046a9:	75 25                	jne    801046d0 <memset+0x40>
    c &= 0xFF;
801046ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ae:	c1 e0 18             	shl    $0x18,%eax
801046b1:	89 fb                	mov    %edi,%ebx
801046b3:	c1 e9 02             	shr    $0x2,%ecx
801046b6:	c1 e3 10             	shl    $0x10,%ebx
801046b9:	09 d8                	or     %ebx,%eax
801046bb:	09 f8                	or     %edi,%eax
801046bd:	c1 e7 08             	shl    $0x8,%edi
801046c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046c2:	89 d7                	mov    %edx,%edi
801046c4:	fc                   	cld    
801046c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046c7:	5b                   	pop    %ebx
801046c8:	89 d0                	mov    %edx,%eax
801046ca:	5f                   	pop    %edi
801046cb:	5d                   	pop    %ebp
801046cc:	c3                   	ret    
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801046d0:	89 d7                	mov    %edx,%edi
801046d2:	fc                   	cld    
801046d3:	f3 aa                	rep stos %al,%es:(%edi)
801046d5:	5b                   	pop    %ebx
801046d6:	89 d0                	mov    %edx,%eax
801046d8:	5f                   	pop    %edi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	8b 75 10             	mov    0x10(%ebp),%esi
801046eb:	8b 55 08             	mov    0x8(%ebp),%edx
801046ee:	53                   	push   %ebx
801046ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046f2:	85 f6                	test   %esi,%esi
801046f4:	74 2a                	je     80104720 <memcmp+0x40>
801046f6:	01 c6                	add    %eax,%esi
801046f8:	eb 10                	jmp    8010470a <memcmp+0x2a>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104706:	39 f0                	cmp    %esi,%eax
80104708:	74 16                	je     80104720 <memcmp+0x40>
    if(*s1 != *s2)
8010470a:	0f b6 0a             	movzbl (%edx),%ecx
8010470d:	0f b6 18             	movzbl (%eax),%ebx
80104710:	38 d9                	cmp    %bl,%cl
80104712:	74 ec                	je     80104700 <memcmp+0x20>
      return *s1 - *s2;
80104714:	0f b6 c1             	movzbl %cl,%eax
80104717:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	5b                   	pop    %ebx
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473e:	56                   	push   %esi
8010473f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104742:	39 d6                	cmp    %edx,%esi
80104744:	73 2a                	jae    80104770 <memmove+0x40>
80104746:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104749:	39 fa                	cmp    %edi,%edx
8010474b:	73 23                	jae    80104770 <memmove+0x40>
8010474d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104750:	85 c9                	test   %ecx,%ecx
80104752:	74 13                	je     80104767 <memmove+0x37>
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104758:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010475c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010475f:	83 e8 01             	sub    $0x1,%eax
80104762:	83 f8 ff             	cmp    $0xffffffff,%eax
80104765:	75 f1                	jne    80104758 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104767:	5e                   	pop    %esi
80104768:	89 d0                	mov    %edx,%eax
8010476a:	5f                   	pop    %edi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104770:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104773:	89 d7                	mov    %edx,%edi
80104775:	85 c9                	test   %ecx,%ecx
80104777:	74 ee                	je     80104767 <memmove+0x37>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104780:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104781:	39 f0                	cmp    %esi,%eax
80104783:	75 fb                	jne    80104780 <memmove+0x50>
}
80104785:	5e                   	pop    %esi
80104786:	89 d0                	mov    %edx,%eax
80104788:	5f                   	pop    %edi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104794:	eb 9a                	jmp    80104730 <memmove>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	56                   	push   %esi
801047a8:	8b 75 10             	mov    0x10(%ebp),%esi
801047ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ae:	53                   	push   %ebx
801047af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047b2:	85 f6                	test   %esi,%esi
801047b4:	74 32                	je     801047e8 <strncmp+0x48>
801047b6:	01 c6                	add    %eax,%esi
801047b8:	eb 14                	jmp    801047ce <strncmp+0x2e>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c0:	38 da                	cmp    %bl,%dl
801047c2:	75 14                	jne    801047d8 <strncmp+0x38>
    n--, p++, q++;
801047c4:	83 c0 01             	add    $0x1,%eax
801047c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ca:	39 f0                	cmp    %esi,%eax
801047cc:	74 1a                	je     801047e8 <strncmp+0x48>
801047ce:	0f b6 11             	movzbl (%ecx),%edx
801047d1:	0f b6 18             	movzbl (%eax),%ebx
801047d4:	84 d2                	test   %dl,%dl
801047d6:	75 e8                	jne    801047c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d8:	0f b6 c2             	movzbl %dl,%eax
801047db:	29 d8                	sub    %ebx,%eax
}
801047dd:	5b                   	pop    %ebx
801047de:	5e                   	pop    %esi
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	5b                   	pop    %ebx
    return 0;
801047e9:	31 c0                	xor    %eax,%eax
}
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
801047ed:	c3                   	ret    
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	57                   	push   %edi
801047f8:	56                   	push   %esi
801047f9:	8b 75 08             	mov    0x8(%ebp),%esi
801047fc:	53                   	push   %ebx
801047fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104800:	89 f2                	mov    %esi,%edx
80104802:	eb 1b                	jmp    8010481f <strncpy+0x2f>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104808:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010480c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010480f:	83 c2 01             	add    $0x1,%edx
80104812:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104816:	89 f9                	mov    %edi,%ecx
80104818:	88 4a ff             	mov    %cl,-0x1(%edx)
8010481b:	84 c9                	test   %cl,%cl
8010481d:	74 09                	je     80104828 <strncpy+0x38>
8010481f:	89 c3                	mov    %eax,%ebx
80104821:	83 e8 01             	sub    $0x1,%eax
80104824:	85 db                	test   %ebx,%ebx
80104826:	7f e0                	jg     80104808 <strncpy+0x18>
    ;
  while(n-- > 0)
80104828:	89 d1                	mov    %edx,%ecx
8010482a:	85 c0                	test   %eax,%eax
8010482c:	7e 15                	jle    80104843 <strncpy+0x53>
8010482e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104830:	83 c1 01             	add    $0x1,%ecx
80104833:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104837:	89 c8                	mov    %ecx,%eax
80104839:	f7 d0                	not    %eax
8010483b:	01 d0                	add    %edx,%eax
8010483d:	01 d8                	add    %ebx,%eax
8010483f:	85 c0                	test   %eax,%eax
80104841:	7f ed                	jg     80104830 <strncpy+0x40>
  return os;
}
80104843:	5b                   	pop    %ebx
80104844:	89 f0                	mov    %esi,%eax
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	8b 55 10             	mov    0x10(%ebp),%edx
8010485b:	8b 75 08             	mov    0x8(%ebp),%esi
8010485e:	53                   	push   %ebx
8010485f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104862:	85 d2                	test   %edx,%edx
80104864:	7e 21                	jle    80104887 <safestrcpy+0x37>
80104866:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010486a:	89 f2                	mov    %esi,%edx
8010486c:	eb 12                	jmp    80104880 <safestrcpy+0x30>
8010486e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104870:	0f b6 08             	movzbl (%eax),%ecx
80104873:	83 c0 01             	add    $0x1,%eax
80104876:	83 c2 01             	add    $0x1,%edx
80104879:	88 4a ff             	mov    %cl,-0x1(%edx)
8010487c:	84 c9                	test   %cl,%cl
8010487e:	74 04                	je     80104884 <safestrcpy+0x34>
80104880:	39 d8                	cmp    %ebx,%eax
80104882:	75 ec                	jne    80104870 <safestrcpy+0x20>
    ;
  *s = 0;
80104884:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104887:	89 f0                	mov    %esi,%eax
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strlen>:

int
strlen(const char *s)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104895:	31 c0                	xor    %eax,%eax
{
80104897:	89 e5                	mov    %esp,%ebp
80104899:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010489c:	80 3a 00             	cmpb   $0x0,(%edx)
8010489f:	74 10                	je     801048b1 <strlen+0x21>
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a8:	83 c0 01             	add    $0x1,%eax
801048ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048af:	75 f7                	jne    801048a8 <strlen+0x18>
    ;
  return n;
}
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    

801048b3 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048bb:	55                   	push   %ebp
  pushl %ebx
801048bc:	53                   	push   %ebx
  pushl %esi
801048bd:	56                   	push   %esi
  pushl %edi
801048be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048c1:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048c3:	5f                   	pop    %edi
  popl %esi
801048c4:	5e                   	pop    %esi
  popl %ebx
801048c5:	5b                   	pop    %ebx
  popl %ebp
801048c6:	5d                   	pop    %ebp
  ret
801048c7:	c3                   	ret    
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp

//cs 153 lab 2 (TODO 3)
//this checked for out of bounds calls of user space 
//  if(addr >= curproc->sz || addr+4 > curproc->sz)
//    return -1;
  *ip = *(int*)(addr);
801048d7:	8b 45 08             	mov    0x8(%ebp),%eax
801048da:	8b 10                	mov    (%eax),%edx
801048dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048df:	89 10                	mov    %edx,(%eax)
  return 0;
}
801048e1:	31 c0                	xor    %eax,%eax
801048e3:	5d                   	pop    %ebp
801048e4:	c3                   	ret    
801048e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	8b 55 08             	mov    0x8(%ebp),%edx

//cs 153 lab 2 (TODO 3)
//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
801048fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fd:	89 10                	mov    %edx,(%eax)

//cs 153 lab 2 (TODO 3)
//  ep = (char*)curproc->sz;
  ep = (char*)STACKBASE;

  for(s = *pp; s < ep; s++){
801048ff:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
80104905:	77 21                	ja     80104928 <fetchstr+0x38>
80104907:	89 d0                	mov    %edx,%eax
80104909:	eb 0f                	jmp    8010491a <fetchstr+0x2a>
8010490b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
80104918:	74 0e                	je     80104928 <fetchstr+0x38>
    if(*s == 0)
8010491a:	80 38 00             	cmpb   $0x0,(%eax)
8010491d:	75 f1                	jne    80104910 <fetchstr+0x20>
      return s - *pp;
8010491f:	29 d0                	sub    %edx,%eax
  }

  return -1;
}
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104927:	90                   	nop
  return -1;
80104928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010492d:	5d                   	pop    %ebp
8010492e:	c3                   	ret    
8010492f:	90                   	nop

80104930 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010493a:	e8 71 f0 ff ff       	call   801039b0 <myproc>
  *ip = *(int*)(addr);
8010493f:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104942:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104945:	8b 40 44             	mov    0x44(%eax),%eax
80104948:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
8010494c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010494f:	89 10                	mov    %edx,(%eax)
}
80104951:	31 c0                	xor    %eax,%eax
80104953:	c9                   	leave  
80104954:	c3                   	ret    
80104955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010496a:	e8 41 f0 ff ff       	call   801039b0 <myproc>
  *ip = *(int*)(addr);
8010496f:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104972:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104975:	8b 40 44             	mov    0x44(%eax),%eax
80104978:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 
  if(argint(n, &i) < 0)
    return -1;
//cs 153 lab 2 (TODO 3)
// if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  if(size < 0)
8010497c:	8b 55 10             	mov    0x10(%ebp),%edx
8010497f:	85 d2                	test   %edx,%edx
80104981:	78 09                	js     8010498c <argptr+0x2c>
    return -1;

  *pp = (char*)i;
80104983:	8b 55 0c             	mov    0xc(%ebp),%edx
80104986:	89 02                	mov    %eax,(%edx)
  return 0;
80104988:	31 c0                	xor    %eax,%eax
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	c9                   	leave  
    return -1;
8010498d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104992:	c3                   	ret    
80104993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049aa:	e8 01 f0 ff ff       	call   801039b0 <myproc>
  *pp = (char*)addr;
801049af:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b2:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
801049b5:	8b 40 44             	mov    0x44(%eax),%eax
  *pp = (char*)addr;
801049b8:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
801049bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049bf:	89 10                	mov    %edx,(%eax)
  for(s = *pp; s < ep; s++){
801049c1:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
801049c7:	77 1f                	ja     801049e8 <argstr+0x48>
801049c9:	89 d0                	mov    %edx,%eax
801049cb:	eb 0d                	jmp    801049da <argstr+0x3a>
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
801049d0:	83 c0 01             	add    $0x1,%eax
801049d3:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801049d8:	77 0e                	ja     801049e8 <argstr+0x48>
    if(*s == 0)
801049da:	80 38 00             	cmpb   $0x0,(%eax)
801049dd:	75 f1                	jne    801049d0 <argstr+0x30>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801049df:	c9                   	leave  
      return s - *pp;
801049e0:	29 d0                	sub    %edx,%eax
}
801049e2:	c3                   	ret    
801049e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e7:	90                   	nop
801049e8:	c9                   	leave  
  return -1;
801049e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049ee:	c3                   	ret    
801049ef:	90                   	nop

801049f0 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	53                   	push   %ebx
801049f8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049fb:	e8 b0 ef ff ff       	call   801039b0 <myproc>
80104a00:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a02:	8b 40 18             	mov    0x18(%eax),%eax
80104a05:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a08:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a0b:	83 fa 16             	cmp    $0x16,%edx
80104a0e:	77 20                	ja     80104a30 <syscall+0x40>
80104a10:	8b 14 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%edx
80104a17:	85 d2                	test   %edx,%edx
80104a19:	74 15                	je     80104a30 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a1b:	ff d2                	call   *%edx
80104a1d:	89 c2                	mov    %eax,%edx
80104a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80104a22:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a28:	c9                   	leave  
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a34:	50                   	push   %eax
80104a35:	ff 73 10             	pushl  0x10(%ebx)
80104a38:	68 bd 79 10 80       	push   $0x801079bd
80104a3d:	e8 6e bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104a42:	8b 43 18             	mov    0x18(%ebx),%eax
80104a45:	83 c4 10             	add    $0x10,%esp
80104a48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
80104a54:	66 90                	xchg   %ax,%ax
80104a56:	66 90                	xchg   %ax,%ax
80104a58:	66 90                	xchg   %ax,%ax
80104a5a:	66 90                	xchg   %ax,%ax
80104a5c:	66 90                	xchg   %ax,%ax
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104a68:	53                   	push   %ebx
80104a69:	83 ec 44             	sub    $0x44,%esp
80104a6c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a72:	57                   	push   %edi
80104a73:	50                   	push   %eax
{
80104a74:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a77:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a7a:	e8 11 d6 ff ff       	call   80102090 <nameiparent>
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	85 c0                	test   %eax,%eax
80104a84:	0f 84 46 01 00 00    	je     80104bd0 <create+0x170>
    return 0;
  ilock(dp);
80104a8a:	83 ec 0c             	sub    $0xc,%esp
80104a8d:	89 c3                	mov    %eax,%ebx
80104a8f:	50                   	push   %eax
80104a90:	e8 0b cd ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a95:	83 c4 0c             	add    $0xc,%esp
80104a98:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a9b:	50                   	push   %eax
80104a9c:	57                   	push   %edi
80104a9d:	53                   	push   %ebx
80104a9e:	e8 4d d2 ff ff       	call   80101cf0 <dirlookup>
80104aa3:	83 c4 10             	add    $0x10,%esp
80104aa6:	89 c6                	mov    %eax,%esi
80104aa8:	85 c0                	test   %eax,%eax
80104aaa:	74 54                	je     80104b00 <create+0xa0>
    iunlockput(dp);
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	53                   	push   %ebx
80104ab0:	e8 8b cf ff ff       	call   80101a40 <iunlockput>
    ilock(ip);
80104ab5:	89 34 24             	mov    %esi,(%esp)
80104ab8:	e8 e3 cc ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104abd:	83 c4 10             	add    $0x10,%esp
80104ac0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ac5:	75 19                	jne    80104ae0 <create+0x80>
80104ac7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104acc:	75 12                	jne    80104ae0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad1:	89 f0                	mov    %esi,%eax
80104ad3:	5b                   	pop    %ebx
80104ad4:	5e                   	pop    %esi
80104ad5:	5f                   	pop    %edi
80104ad6:	5d                   	pop    %ebp
80104ad7:	c3                   	ret    
80104ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104adf:	90                   	nop
    iunlockput(ip);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	56                   	push   %esi
    return 0;
80104ae4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ae6:	e8 55 cf ff ff       	call   80101a40 <iunlockput>
    return 0;
80104aeb:	83 c4 10             	add    $0x10,%esp
}
80104aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af1:	89 f0                	mov    %esi,%eax
80104af3:	5b                   	pop    %ebx
80104af4:	5e                   	pop    %esi
80104af5:	5f                   	pop    %edi
80104af6:	5d                   	pop    %ebp
80104af7:	c3                   	ret    
80104af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b00:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b04:	83 ec 08             	sub    $0x8,%esp
80104b07:	50                   	push   %eax
80104b08:	ff 33                	pushl  (%ebx)
80104b0a:	e8 11 cb ff ff       	call   80101620 <ialloc>
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	89 c6                	mov    %eax,%esi
80104b14:	85 c0                	test   %eax,%eax
80104b16:	0f 84 cd 00 00 00    	je     80104be9 <create+0x189>
  ilock(ip);
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	50                   	push   %eax
80104b20:	e8 7b cc ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104b25:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b29:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b2d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b31:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b35:	b8 01 00 00 00       	mov    $0x1,%eax
80104b3a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b3e:	89 34 24             	mov    %esi,(%esp)
80104b41:	e8 9a cb ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b46:	83 c4 10             	add    $0x10,%esp
80104b49:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b4e:	74 30                	je     80104b80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b50:	83 ec 04             	sub    $0x4,%esp
80104b53:	ff 76 04             	pushl  0x4(%esi)
80104b56:	57                   	push   %edi
80104b57:	53                   	push   %ebx
80104b58:	e8 53 d4 ff ff       	call   80101fb0 <dirlink>
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 78                	js     80104bdc <create+0x17c>
  iunlockput(dp);
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	53                   	push   %ebx
80104b68:	e8 d3 ce ff ff       	call   80101a40 <iunlockput>
  return ip;
80104b6d:	83 c4 10             	add    $0x10,%esp
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	89 f0                	mov    %esi,%eax
80104b75:	5b                   	pop    %ebx
80104b76:	5e                   	pop    %esi
80104b77:	5f                   	pop    %edi
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b88:	53                   	push   %ebx
80104b89:	e8 52 cb ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b8e:	83 c4 0c             	add    $0xc,%esp
80104b91:	ff 76 04             	pushl  0x4(%esi)
80104b94:	68 5c 7a 10 80       	push   $0x80107a5c
80104b99:	56                   	push   %esi
80104b9a:	e8 11 d4 ff ff       	call   80101fb0 <dirlink>
80104b9f:	83 c4 10             	add    $0x10,%esp
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	78 18                	js     80104bbe <create+0x15e>
80104ba6:	83 ec 04             	sub    $0x4,%esp
80104ba9:	ff 73 04             	pushl  0x4(%ebx)
80104bac:	68 5b 7a 10 80       	push   $0x80107a5b
80104bb1:	56                   	push   %esi
80104bb2:	e8 f9 d3 ff ff       	call   80101fb0 <dirlink>
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	79 92                	jns    80104b50 <create+0xf0>
      panic("create dots");
80104bbe:	83 ec 0c             	sub    $0xc,%esp
80104bc1:	68 4f 7a 10 80       	push   $0x80107a4f
80104bc6:	e8 c5 b7 ff ff       	call   80100390 <panic>
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bd3:	31 f6                	xor    %esi,%esi
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	89 f0                	mov    %esi,%eax
80104bd8:	5e                   	pop    %esi
80104bd9:	5f                   	pop    %edi
80104bda:	5d                   	pop    %ebp
80104bdb:	c3                   	ret    
    panic("create: dirlink");
80104bdc:	83 ec 0c             	sub    $0xc,%esp
80104bdf:	68 5e 7a 10 80       	push   $0x80107a5e
80104be4:	e8 a7 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104be9:	83 ec 0c             	sub    $0xc,%esp
80104bec:	68 40 7a 10 80       	push   $0x80107a40
80104bf1:	e8 9a b7 ff ff       	call   80100390 <panic>
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	89 d6                	mov    %edx,%esi
80104c06:	53                   	push   %ebx
80104c07:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c0f:	50                   	push   %eax
80104c10:	6a 00                	push   $0x0
80104c12:	e8 19 fd ff ff       	call   80104930 <argint>
80104c17:	83 c4 10             	add    $0x10,%esp
80104c1a:	85 c0                	test   %eax,%eax
80104c1c:	78 2a                	js     80104c48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c22:	77 24                	ja     80104c48 <argfd.constprop.0+0x48>
80104c24:	e8 87 ed ff ff       	call   801039b0 <myproc>
80104c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c30:	85 c0                	test   %eax,%eax
80104c32:	74 14                	je     80104c48 <argfd.constprop.0+0x48>
  if(pfd)
80104c34:	85 db                	test   %ebx,%ebx
80104c36:	74 02                	je     80104c3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c3a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c3c:	31 c0                	xor    %eax,%eax
}
80104c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c41:	5b                   	pop    %ebx
80104c42:	5e                   	pop    %esi
80104c43:	5d                   	pop    %ebp
80104c44:	c3                   	ret    
80104c45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c4d:	eb ef                	jmp    80104c3e <argfd.constprop.0+0x3e>
80104c4f:	90                   	nop

80104c50 <sys_dup>:
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c55:	31 c0                	xor    %eax,%eax
{
80104c57:	89 e5                	mov    %esp,%ebp
80104c59:	56                   	push   %esi
80104c5a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c5b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c5e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c61:	e8 9a ff ff ff       	call   80104c00 <argfd.constprop.0>
80104c66:	85 c0                	test   %eax,%eax
80104c68:	78 1e                	js     80104c88 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104c6a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c6d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c6f:	e8 3c ed ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104c78:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c7c:	85 d2                	test   %edx,%edx
80104c7e:	74 20                	je     80104ca0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104c80:	83 c3 01             	add    $0x1,%ebx
80104c83:	83 fb 10             	cmp    $0x10,%ebx
80104c86:	75 f0                	jne    80104c78 <sys_dup+0x28>
}
80104c88:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c90:	89 d8                	mov    %ebx,%eax
80104c92:	5b                   	pop    %ebx
80104c93:	5e                   	pop    %esi
80104c94:	5d                   	pop    %ebp
80104c95:	c3                   	ret    
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ca0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80104caa:	e8 01 c2 ff ff       	call   80100eb0 <filedup>
  return fd;
80104caf:	83 c4 10             	add    $0x10,%esp
}
80104cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb5:	89 d8                	mov    %ebx,%eax
80104cb7:	5b                   	pop    %ebx
80104cb8:	5e                   	pop    %esi
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop

80104cc0 <sys_read>:
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc5:	31 c0                	xor    %eax,%eax
{
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ccc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ccf:	e8 2c ff ff ff       	call   80104c00 <argfd.constprop.0>
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	78 48                	js     80104d20 <sys_read+0x60>
80104cd8:	83 ec 08             	sub    $0x8,%esp
80104cdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cde:	50                   	push   %eax
80104cdf:	6a 02                	push   $0x2
80104ce1:	e8 4a fc ff ff       	call   80104930 <argint>
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	78 33                	js     80104d20 <sys_read+0x60>
80104ced:	83 ec 04             	sub    $0x4,%esp
80104cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf3:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf6:	50                   	push   %eax
80104cf7:	6a 01                	push   $0x1
80104cf9:	e8 62 fc ff ff       	call   80104960 <argptr>
80104cfe:	83 c4 10             	add    $0x10,%esp
80104d01:	85 c0                	test   %eax,%eax
80104d03:	78 1b                	js     80104d20 <sys_read+0x60>
  return fileread(f, p, n);
80104d05:	83 ec 04             	sub    $0x4,%esp
80104d08:	ff 75 f0             	pushl  -0x10(%ebp)
80104d0b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d0e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d11:	e8 1a c3 ff ff       	call   80101030 <fileread>
80104d16:	83 c4 10             	add    $0x10,%esp
}
80104d19:	c9                   	leave  
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop
80104d20:	c9                   	leave  
    return -1;
80104d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d26:	c3                   	ret    
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <sys_write>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d35:	31 c0                	xor    %eax,%eax
{
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3f:	e8 bc fe ff ff       	call   80104c00 <argfd.constprop.0>
80104d44:	85 c0                	test   %eax,%eax
80104d46:	78 48                	js     80104d90 <sys_write+0x60>
80104d48:	83 ec 08             	sub    $0x8,%esp
80104d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4e:	50                   	push   %eax
80104d4f:	6a 02                	push   $0x2
80104d51:	e8 da fb ff ff       	call   80104930 <argint>
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	78 33                	js     80104d90 <sys_write+0x60>
80104d5d:	83 ec 04             	sub    $0x4,%esp
80104d60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d63:	ff 75 f0             	pushl  -0x10(%ebp)
80104d66:	50                   	push   %eax
80104d67:	6a 01                	push   $0x1
80104d69:	e8 f2 fb ff ff       	call   80104960 <argptr>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 1b                	js     80104d90 <sys_write+0x60>
  return filewrite(f, p, n);
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	pushl  -0x10(%ebp)
80104d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d81:	e8 4a c3 ff ff       	call   801010d0 <filewrite>
80104d86:	83 c4 10             	add    $0x10,%esp
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_close>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104daa:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db0:	e8 4b fe ff ff       	call   80104c00 <argfd.constprop.0>
80104db5:	85 c0                	test   %eax,%eax
80104db7:	78 27                	js     80104de0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104db9:	e8 f2 eb ff ff       	call   801039b0 <myproc>
80104dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104dc1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104dc4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104dcb:	00 
  fileclose(f);
80104dcc:	ff 75 f4             	pushl  -0xc(%ebp)
80104dcf:	e8 2c c1 ff ff       	call   80100f00 <fileclose>
  return 0;
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	31 c0                	xor    %eax,%eax
}
80104dd9:	c9                   	leave  
80104dda:	c3                   	ret    
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop
80104de0:	c9                   	leave  
    return -1;
80104de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de6:	c3                   	ret    
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <sys_fstat>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104df5:	31 c0                	xor    %eax,%eax
{
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dfc:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dff:	e8 fc fd ff ff       	call   80104c00 <argfd.constprop.0>
80104e04:	85 c0                	test   %eax,%eax
80104e06:	78 30                	js     80104e38 <sys_fstat+0x48>
80104e08:	83 ec 04             	sub    $0x4,%esp
80104e0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e0e:	6a 14                	push   $0x14
80104e10:	50                   	push   %eax
80104e11:	6a 01                	push   $0x1
80104e13:	e8 48 fb ff ff       	call   80104960 <argptr>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	78 19                	js     80104e38 <sys_fstat+0x48>
  return filestat(f, st);
80104e1f:	83 ec 08             	sub    $0x8,%esp
80104e22:	ff 75 f4             	pushl  -0xc(%ebp)
80104e25:	ff 75 f0             	pushl  -0x10(%ebp)
80104e28:	e8 b3 c1 ff ff       	call   80100fe0 <filestat>
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e38:	c9                   	leave  
    return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop

80104e40 <sys_link>:
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	57                   	push   %edi
80104e48:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e4c:	53                   	push   %ebx
80104e4d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e50:	50                   	push   %eax
80104e51:	6a 00                	push   $0x0
80104e53:	e8 48 fb ff ff       	call   801049a0 <argstr>
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	0f 88 ff 00 00 00    	js     80104f62 <sys_link+0x122>
80104e63:	83 ec 08             	sub    $0x8,%esp
80104e66:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e69:	50                   	push   %eax
80104e6a:	6a 01                	push   $0x1
80104e6c:	e8 2f fb ff ff       	call   801049a0 <argstr>
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	85 c0                	test   %eax,%eax
80104e76:	0f 88 e6 00 00 00    	js     80104f62 <sys_link+0x122>
  begin_op();
80104e7c:	e8 ef de ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e87:	e8 e4 d1 ff ff       	call   80102070 <namei>
80104e8c:	83 c4 10             	add    $0x10,%esp
80104e8f:	89 c3                	mov    %eax,%ebx
80104e91:	85 c0                	test   %eax,%eax
80104e93:	0f 84 e8 00 00 00    	je     80104f81 <sys_link+0x141>
  ilock(ip);
80104e99:	83 ec 0c             	sub    $0xc,%esp
80104e9c:	50                   	push   %eax
80104e9d:	e8 fe c8 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eaa:	0f 84 b9 00 00 00    	je     80104f69 <sys_link+0x129>
  iupdate(ip);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104eb8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ebb:	53                   	push   %ebx
80104ebc:	e8 1f c8 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
80104ec1:	89 1c 24             	mov    %ebx,(%esp)
80104ec4:	e8 b7 c9 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ec9:	58                   	pop    %eax
80104eca:	5a                   	pop    %edx
80104ecb:	57                   	push   %edi
80104ecc:	ff 75 d0             	pushl  -0x30(%ebp)
80104ecf:	e8 bc d1 ff ff       	call   80102090 <nameiparent>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	89 c6                	mov    %eax,%esi
80104ed9:	85 c0                	test   %eax,%eax
80104edb:	74 5f                	je     80104f3c <sys_link+0xfc>
  ilock(dp);
80104edd:	83 ec 0c             	sub    $0xc,%esp
80104ee0:	50                   	push   %eax
80104ee1:	e8 ba c8 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ee6:	8b 03                	mov    (%ebx),%eax
80104ee8:	83 c4 10             	add    $0x10,%esp
80104eeb:	39 06                	cmp    %eax,(%esi)
80104eed:	75 41                	jne    80104f30 <sys_link+0xf0>
80104eef:	83 ec 04             	sub    $0x4,%esp
80104ef2:	ff 73 04             	pushl  0x4(%ebx)
80104ef5:	57                   	push   %edi
80104ef6:	56                   	push   %esi
80104ef7:	e8 b4 d0 ff ff       	call   80101fb0 <dirlink>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	78 2d                	js     80104f30 <sys_link+0xf0>
  iunlockput(dp);
80104f03:	83 ec 0c             	sub    $0xc,%esp
80104f06:	56                   	push   %esi
80104f07:	e8 34 cb ff ff       	call   80101a40 <iunlockput>
  iput(ip);
80104f0c:	89 1c 24             	mov    %ebx,(%esp)
80104f0f:	e8 bc c9 ff ff       	call   801018d0 <iput>
  end_op();
80104f14:	e8 c7 de ff ff       	call   80102de0 <end_op>
  return 0;
80104f19:	83 c4 10             	add    $0x10,%esp
80104f1c:	31 c0                	xor    %eax,%eax
}
80104f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f21:	5b                   	pop    %ebx
80104f22:	5e                   	pop    %esi
80104f23:	5f                   	pop    %edi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	56                   	push   %esi
80104f34:	e8 07 cb ff ff       	call   80101a40 <iunlockput>
    goto bad;
80104f39:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	53                   	push   %ebx
80104f40:	e8 5b c8 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80104f45:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f4a:	89 1c 24             	mov    %ebx,(%esp)
80104f4d:	e8 8e c7 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80104f52:	89 1c 24             	mov    %ebx,(%esp)
80104f55:	e8 e6 ca ff ff       	call   80101a40 <iunlockput>
  end_op();
80104f5a:	e8 81 de ff ff       	call   80102de0 <end_op>
  return -1;
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f67:	eb b5                	jmp    80104f1e <sys_link+0xde>
    iunlockput(ip);
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	53                   	push   %ebx
80104f6d:	e8 ce ca ff ff       	call   80101a40 <iunlockput>
    end_op();
80104f72:	e8 69 de ff ff       	call   80102de0 <end_op>
    return -1;
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7f:	eb 9d                	jmp    80104f1e <sys_link+0xde>
    end_op();
80104f81:	e8 5a de ff ff       	call   80102de0 <end_op>
    return -1;
80104f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8b:	eb 91                	jmp    80104f1e <sys_link+0xde>
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <sys_unlink>:
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	57                   	push   %edi
80104f98:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f99:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f9c:	53                   	push   %ebx
80104f9d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104fa0:	50                   	push   %eax
80104fa1:	6a 00                	push   $0x0
80104fa3:	e8 f8 f9 ff ff       	call   801049a0 <argstr>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	85 c0                	test   %eax,%eax
80104fad:	0f 88 7d 01 00 00    	js     80105130 <sys_unlink+0x1a0>
  begin_op();
80104fb3:	e8 b8 dd ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fb8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fbb:	83 ec 08             	sub    $0x8,%esp
80104fbe:	53                   	push   %ebx
80104fbf:	ff 75 c0             	pushl  -0x40(%ebp)
80104fc2:	e8 c9 d0 ff ff       	call   80102090 <nameiparent>
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	89 c6                	mov    %eax,%esi
80104fcc:	85 c0                	test   %eax,%eax
80104fce:	0f 84 66 01 00 00    	je     8010513a <sys_unlink+0x1aa>
  ilock(dp);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	50                   	push   %eax
80104fd8:	e8 c3 c7 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fdd:	58                   	pop    %eax
80104fde:	5a                   	pop    %edx
80104fdf:	68 5c 7a 10 80       	push   $0x80107a5c
80104fe4:	53                   	push   %ebx
80104fe5:	e8 e6 cc ff ff       	call   80101cd0 <namecmp>
80104fea:	83 c4 10             	add    $0x10,%esp
80104fed:	85 c0                	test   %eax,%eax
80104fef:	0f 84 03 01 00 00    	je     801050f8 <sys_unlink+0x168>
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	68 5b 7a 10 80       	push   $0x80107a5b
80104ffd:	53                   	push   %ebx
80104ffe:	e8 cd cc ff ff       	call   80101cd0 <namecmp>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	0f 84 ea 00 00 00    	je     801050f8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010500e:	83 ec 04             	sub    $0x4,%esp
80105011:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105014:	50                   	push   %eax
80105015:	53                   	push   %ebx
80105016:	56                   	push   %esi
80105017:	e8 d4 cc ff ff       	call   80101cf0 <dirlookup>
8010501c:	83 c4 10             	add    $0x10,%esp
8010501f:	89 c3                	mov    %eax,%ebx
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 cf 00 00 00    	je     801050f8 <sys_unlink+0x168>
  ilock(ip);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 6e c7 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010503a:	0f 8e 23 01 00 00    	jle    80105163 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105040:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105045:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105048:	74 66                	je     801050b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	6a 10                	push   $0x10
8010504f:	6a 00                	push   $0x0
80105051:	57                   	push   %edi
80105052:	e8 39 f6 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105057:	6a 10                	push   $0x10
80105059:	ff 75 c4             	pushl  -0x3c(%ebp)
8010505c:	57                   	push   %edi
8010505d:	56                   	push   %esi
8010505e:	e8 3d cb ff ff       	call   80101ba0 <writei>
80105063:	83 c4 20             	add    $0x20,%esp
80105066:	83 f8 10             	cmp    $0x10,%eax
80105069:	0f 85 e7 00 00 00    	jne    80105156 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010506f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105074:	0f 84 96 00 00 00    	je     80105110 <sys_unlink+0x180>
  iunlockput(dp);
8010507a:	83 ec 0c             	sub    $0xc,%esp
8010507d:	56                   	push   %esi
8010507e:	e8 bd c9 ff ff       	call   80101a40 <iunlockput>
  ip->nlink--;
80105083:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105088:	89 1c 24             	mov    %ebx,(%esp)
8010508b:	e8 50 c6 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105090:	89 1c 24             	mov    %ebx,(%esp)
80105093:	e8 a8 c9 ff ff       	call   80101a40 <iunlockput>
  end_op();
80105098:	e8 43 dd ff ff       	call   80102de0 <end_op>
  return 0;
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	31 c0                	xor    %eax,%eax
}
801050a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a5:	5b                   	pop    %ebx
801050a6:	5e                   	pop    %esi
801050a7:	5f                   	pop    %edi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050b4:	76 94                	jbe    8010504a <sys_unlink+0xba>
801050b6:	ba 20 00 00 00       	mov    $0x20,%edx
801050bb:	eb 0b                	jmp    801050c8 <sys_unlink+0x138>
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
801050c0:	83 c2 10             	add    $0x10,%edx
801050c3:	39 53 58             	cmp    %edx,0x58(%ebx)
801050c6:	76 82                	jbe    8010504a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050c8:	6a 10                	push   $0x10
801050ca:	52                   	push   %edx
801050cb:	57                   	push   %edi
801050cc:	53                   	push   %ebx
801050cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801050d0:	e8 cb c9 ff ff       	call   80101aa0 <readi>
801050d5:	83 c4 10             	add    $0x10,%esp
801050d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801050db:	83 f8 10             	cmp    $0x10,%eax
801050de:	75 69                	jne    80105149 <sys_unlink+0x1b9>
    if(de.inum != 0)
801050e0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050e5:	74 d9                	je     801050c0 <sys_unlink+0x130>
    iunlockput(ip);
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	53                   	push   %ebx
801050eb:	e8 50 c9 ff ff       	call   80101a40 <iunlockput>
    goto bad;
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f7:	90                   	nop
  iunlockput(dp);
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	56                   	push   %esi
801050fc:	e8 3f c9 ff ff       	call   80101a40 <iunlockput>
  end_op();
80105101:	e8 da dc ff ff       	call   80102de0 <end_op>
  return -1;
80105106:	83 c4 10             	add    $0x10,%esp
80105109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510e:	eb 92                	jmp    801050a2 <sys_unlink+0x112>
    iupdate(dp);
80105110:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105113:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105118:	56                   	push   %esi
80105119:	e8 c2 c5 ff ff       	call   801016e0 <iupdate>
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	e9 54 ff ff ff       	jmp    8010507a <sys_unlink+0xea>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	e9 68 ff ff ff       	jmp    801050a2 <sys_unlink+0x112>
    end_op();
8010513a:	e8 a1 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010513f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105144:	e9 59 ff ff ff       	jmp    801050a2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	68 80 7a 10 80       	push   $0x80107a80
80105151:	e8 3a b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105156:	83 ec 0c             	sub    $0xc,%esp
80105159:	68 92 7a 10 80       	push   $0x80107a92
8010515e:	e8 2d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105163:	83 ec 0c             	sub    $0xc,%esp
80105166:	68 6e 7a 10 80       	push   $0x80107a6e
8010516b:	e8 20 b2 ff ff       	call   80100390 <panic>

80105170 <sys_open>:

int
sys_open(void)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	57                   	push   %edi
80105178:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105179:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010517c:	53                   	push   %ebx
8010517d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105180:	50                   	push   %eax
80105181:	6a 00                	push   $0x0
80105183:	e8 18 f8 ff ff       	call   801049a0 <argstr>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	0f 88 8a 00 00 00    	js     8010521d <sys_open+0xad>
80105193:	83 ec 08             	sub    $0x8,%esp
80105196:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105199:	50                   	push   %eax
8010519a:	6a 01                	push   $0x1
8010519c:	e8 8f f7 ff ff       	call   80104930 <argint>
801051a1:	83 c4 10             	add    $0x10,%esp
801051a4:	85 c0                	test   %eax,%eax
801051a6:	78 75                	js     8010521d <sys_open+0xad>
    return -1;

  begin_op();
801051a8:	e8 c3 db ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
801051ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051b1:	75 75                	jne    80105228 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051b3:	83 ec 0c             	sub    $0xc,%esp
801051b6:	ff 75 e0             	pushl  -0x20(%ebp)
801051b9:	e8 b2 ce ff ff       	call   80102070 <namei>
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	89 c6                	mov    %eax,%esi
801051c3:	85 c0                	test   %eax,%eax
801051c5:	74 7e                	je     80105245 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801051c7:	83 ec 0c             	sub    $0xc,%esp
801051ca:	50                   	push   %eax
801051cb:	e8 d0 c5 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051d8:	0f 84 c2 00 00 00    	je     801052a0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051de:	e8 5d bc ff ff       	call   80100e40 <filealloc>
801051e3:	89 c7                	mov    %eax,%edi
801051e5:	85 c0                	test   %eax,%eax
801051e7:	74 23                	je     8010520c <sys_open+0x9c>
  struct proc *curproc = myproc();
801051e9:	e8 c2 e7 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051f4:	85 d2                	test   %edx,%edx
801051f6:	74 60                	je     80105258 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051f8:	83 c3 01             	add    $0x1,%ebx
801051fb:	83 fb 10             	cmp    $0x10,%ebx
801051fe:	75 f0                	jne    801051f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	57                   	push   %edi
80105204:	e8 f7 bc ff ff       	call   80100f00 <fileclose>
80105209:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	56                   	push   %esi
80105210:	e8 2b c8 ff ff       	call   80101a40 <iunlockput>
    end_op();
80105215:	e8 c6 db ff ff       	call   80102de0 <end_op>
    return -1;
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105222:	eb 6d                	jmp    80105291 <sys_open+0x121>
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010522e:	31 c9                	xor    %ecx,%ecx
80105230:	ba 02 00 00 00       	mov    $0x2,%edx
80105235:	6a 00                	push   $0x0
80105237:	e8 24 f8 ff ff       	call   80104a60 <create>
    if(ip == 0){
8010523c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010523f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105241:	85 c0                	test   %eax,%eax
80105243:	75 99                	jne    801051de <sys_open+0x6e>
      end_op();
80105245:	e8 96 db ff ff       	call   80102de0 <end_op>
      return -1;
8010524a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010524f:	eb 40                	jmp    80105291 <sys_open+0x121>
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105258:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010525b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010525f:	56                   	push   %esi
80105260:	e8 1b c6 ff ff       	call   80101880 <iunlock>
  end_op();
80105265:	e8 76 db ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010526a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105270:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105273:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105276:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105279:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010527b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105282:	f7 d0                	not    %eax
80105284:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105287:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010528a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010528d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105294:	89 d8                	mov    %ebx,%eax
80105296:	5b                   	pop    %ebx
80105297:	5e                   	pop    %esi
80105298:	5f                   	pop    %edi
80105299:	5d                   	pop    %ebp
8010529a:	c3                   	ret    
8010529b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801052a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052a3:	85 c9                	test   %ecx,%ecx
801052a5:	0f 84 33 ff ff ff    	je     801051de <sys_open+0x6e>
801052ab:	e9 5c ff ff ff       	jmp    8010520c <sys_open+0x9c>

801052b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052ba:	e8 b1 da ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052bf:	83 ec 08             	sub    $0x8,%esp
801052c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c5:	50                   	push   %eax
801052c6:	6a 00                	push   $0x0
801052c8:	e8 d3 f6 ff ff       	call   801049a0 <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 34                	js     80105308 <sys_mkdir+0x58>
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052da:	31 c9                	xor    %ecx,%ecx
801052dc:	ba 01 00 00 00       	mov    $0x1,%edx
801052e1:	6a 00                	push   $0x0
801052e3:	e8 78 f7 ff ff       	call   80104a60 <create>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	74 19                	je     80105308 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ef:	83 ec 0c             	sub    $0xc,%esp
801052f2:	50                   	push   %eax
801052f3:	e8 48 c7 ff ff       	call   80101a40 <iunlockput>
  end_op();
801052f8:	e8 e3 da ff ff       	call   80102de0 <end_op>
  return 0;
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	31 c0                	xor    %eax,%eax
}
80105302:	c9                   	leave  
80105303:	c3                   	ret    
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105308:	e8 d3 da ff ff       	call   80102de0 <end_op>
    return -1;
8010530d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105312:	c9                   	leave  
80105313:	c3                   	ret    
80105314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop

80105320 <sys_mknod>:

int
sys_mknod(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010532a:	e8 41 da ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010532f:	83 ec 08             	sub    $0x8,%esp
80105332:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105335:	50                   	push   %eax
80105336:	6a 00                	push   $0x0
80105338:	e8 63 f6 ff ff       	call   801049a0 <argstr>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	78 64                	js     801053a8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105344:	83 ec 08             	sub    $0x8,%esp
80105347:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010534a:	50                   	push   %eax
8010534b:	6a 01                	push   $0x1
8010534d:	e8 de f5 ff ff       	call   80104930 <argint>
  if((argstr(0, &path)) < 0 ||
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 4f                	js     801053a8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105359:	83 ec 08             	sub    $0x8,%esp
8010535c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535f:	50                   	push   %eax
80105360:	6a 02                	push   $0x2
80105362:	e8 c9 f5 ff ff       	call   80104930 <argint>
     argint(1, &major) < 0 ||
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 3a                	js     801053a8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010536e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105379:	ba 03 00 00 00       	mov    $0x3,%edx
8010537e:	50                   	push   %eax
8010537f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105382:	e8 d9 f6 ff ff       	call   80104a60 <create>
     argint(2, &minor) < 0 ||
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	74 1a                	je     801053a8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538e:	83 ec 0c             	sub    $0xc,%esp
80105391:	50                   	push   %eax
80105392:	e8 a9 c6 ff ff       	call   80101a40 <iunlockput>
  end_op();
80105397:	e8 44 da ff ff       	call   80102de0 <end_op>
  return 0;
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	31 c0                	xor    %eax,%eax
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    
801053a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a7:	90                   	nop
    end_op();
801053a8:	e8 33 da ff ff       	call   80102de0 <end_op>
    return -1;
801053ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop

801053c0 <sys_chdir>:

int
sys_chdir(void)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	56                   	push   %esi
801053c8:	53                   	push   %ebx
801053c9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053cc:	e8 df e5 ff ff       	call   801039b0 <myproc>
801053d1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053d3:	e8 98 d9 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053d8:	83 ec 08             	sub    $0x8,%esp
801053db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053de:	50                   	push   %eax
801053df:	6a 00                	push   $0x0
801053e1:	e8 ba f5 ff ff       	call   801049a0 <argstr>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	78 73                	js     80105460 <sys_chdir+0xa0>
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	ff 75 f4             	pushl  -0xc(%ebp)
801053f3:	e8 78 cc ff ff       	call   80102070 <namei>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	89 c3                	mov    %eax,%ebx
801053fd:	85 c0                	test   %eax,%eax
801053ff:	74 5f                	je     80105460 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	50                   	push   %eax
80105405:	e8 96 c3 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105412:	75 2c                	jne    80105440 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 63 c4 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
8010541d:	58                   	pop    %eax
8010541e:	ff 76 68             	pushl  0x68(%esi)
80105421:	e8 aa c4 ff ff       	call   801018d0 <iput>
  end_op();
80105426:	e8 b5 d9 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
8010542b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	31 c0                	xor    %eax,%eax
}
80105433:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105436:	5b                   	pop    %ebx
80105437:	5e                   	pop    %esi
80105438:	5d                   	pop    %ebp
80105439:	c3                   	ret    
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	53                   	push   %ebx
80105444:	e8 f7 c5 ff ff       	call   80101a40 <iunlockput>
    end_op();
80105449:	e8 92 d9 ff ff       	call   80102de0 <end_op>
    return -1;
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105456:	eb db                	jmp    80105433 <sys_chdir+0x73>
80105458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
    end_op();
80105460:	e8 7b d9 ff ff       	call   80102de0 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546a:	eb c7                	jmp    80105433 <sys_chdir+0x73>
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_exec>:

int
sys_exec(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	57                   	push   %edi
80105478:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105479:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010547f:	53                   	push   %ebx
80105480:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105486:	50                   	push   %eax
80105487:	6a 00                	push   $0x0
80105489:	e8 12 f5 ff ff       	call   801049a0 <argstr>
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	85 c0                	test   %eax,%eax
80105493:	0f 88 8b 00 00 00    	js     80105524 <sys_exec+0xb4>
80105499:	83 ec 08             	sub    $0x8,%esp
8010549c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054a2:	50                   	push   %eax
801054a3:	6a 01                	push   $0x1
801054a5:	e8 86 f4 ff ff       	call   80104930 <argint>
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	85 c0                	test   %eax,%eax
801054af:	78 73                	js     80105524 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054b1:	83 ec 04             	sub    $0x4,%esp
801054b4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801054ba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054bc:	68 80 00 00 00       	push   $0x80
801054c1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054c7:	6a 00                	push   $0x0
801054c9:	50                   	push   %eax
801054ca:	e8 c1 f1 ff ff       	call   80104690 <memset>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054d8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054de:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054e5:	83 ec 08             	sub    $0x8,%esp
801054e8:	57                   	push   %edi
801054e9:	01 f0                	add    %esi,%eax
801054eb:	50                   	push   %eax
801054ec:	e8 df f3 ff ff       	call   801048d0 <fetchint>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	85 c0                	test   %eax,%eax
801054f6:	78 2c                	js     80105524 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801054f8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054fe:	85 c0                	test   %eax,%eax
80105500:	74 36                	je     80105538 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105502:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105508:	83 ec 08             	sub    $0x8,%esp
8010550b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010550e:	52                   	push   %edx
8010550f:	50                   	push   %eax
80105510:	e8 db f3 ff ff       	call   801048f0 <fetchstr>
80105515:	83 c4 10             	add    $0x10,%esp
80105518:	85 c0                	test   %eax,%eax
8010551a:	78 08                	js     80105524 <sys_exec+0xb4>
  for(i=0;; i++){
8010551c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010551f:	83 fb 20             	cmp    $0x20,%ebx
80105522:	75 b4                	jne    801054d8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105524:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010552c:	5b                   	pop    %ebx
8010552d:	5e                   	pop    %esi
8010552e:	5f                   	pop    %edi
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105538:	83 ec 08             	sub    $0x8,%esp
8010553b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105541:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105548:	00 00 00 00 
  return exec(path, argv);
8010554c:	50                   	push   %eax
8010554d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105553:	e8 28 b5 ff ff       	call   80100a80 <exec>
80105558:	83 c4 10             	add    $0x10,%esp
}
8010555b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010555e:	5b                   	pop    %ebx
8010555f:	5e                   	pop    %esi
80105560:	5f                   	pop    %edi
80105561:	5d                   	pop    %ebp
80105562:	c3                   	ret    
80105563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105570 <sys_pipe>:

int
sys_pipe(void)
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	57                   	push   %edi
80105578:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105579:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010557c:	53                   	push   %ebx
8010557d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105580:	6a 08                	push   $0x8
80105582:	50                   	push   %eax
80105583:	6a 00                	push   $0x0
80105585:	e8 d6 f3 ff ff       	call   80104960 <argptr>
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	85 c0                	test   %eax,%eax
8010558f:	78 4e                	js     801055df <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105591:	83 ec 08             	sub    $0x8,%esp
80105594:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105597:	50                   	push   %eax
80105598:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010559b:	50                   	push   %eax
8010559c:	e8 9f de ff ff       	call   80103440 <pipealloc>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 37                	js     801055df <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801055ab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055ad:	e8 fe e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055bc:	85 f6                	test   %esi,%esi
801055be:	74 30                	je     801055f0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c3 01             	add    $0x1,%ebx
801055c3:	83 fb 10             	cmp    $0x10,%ebx
801055c6:	75 f0                	jne    801055b8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	ff 75 e0             	pushl  -0x20(%ebp)
801055ce:	e8 2d b9 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
801055d3:	58                   	pop    %eax
801055d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801055d7:	e8 24 b9 ff ff       	call   80100f00 <fileclose>
    return -1;
801055dc:	83 c4 10             	add    $0x10,%esp
801055df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e4:	eb 5b                	jmp    80105641 <sys_pipe+0xd1>
801055e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055f0:	8d 73 08             	lea    0x8(%ebx),%esi
801055f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055fa:	e8 b1 e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055ff:	31 d2                	xor    %edx,%edx
80105601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105608:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010560c:	85 c9                	test   %ecx,%ecx
8010560e:	74 20                	je     80105630 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105610:	83 c2 01             	add    $0x1,%edx
80105613:	83 fa 10             	cmp    $0x10,%edx
80105616:	75 f0                	jne    80105608 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105618:	e8 93 e3 ff ff       	call   801039b0 <myproc>
8010561d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105624:	00 
80105625:	eb a1                	jmp    801055c8 <sys_pipe+0x58>
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105630:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105634:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105637:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105639:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010563c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010563f:	31 c0                	xor    %eax,%eax
}
80105641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105644:	5b                   	pop    %ebx
80105645:	5e                   	pop    %esi
80105646:	5f                   	pop    %edi
80105647:	5d                   	pop    %ebp
80105648:	c3                   	ret    
80105649:	66 90                	xchg   %ax,%ax
8010564b:	66 90                	xchg   %ax,%ax
8010564d:	66 90                	xchg   %ax,%ax
8010564f:	90                   	nop

80105650 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
8010565a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010565d:	50                   	push   %eax
8010565e:	6a 00                	push   $0x0
80105660:	e8 cb f2 ff ff       	call   80104930 <argint>
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	85 c0                	test   %eax,%eax
8010566a:	78 34                	js     801056a0 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010566c:	83 ec 04             	sub    $0x4,%esp
8010566f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105672:	6a 04                	push   $0x4
80105674:	50                   	push   %eax
80105675:	6a 01                	push   $0x1
80105677:	e8 e4 f2 ff ff       	call   80104960 <argptr>
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	85 c0                	test   %eax,%eax
80105681:	78 1d                	js     801056a0 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	ff 75 f4             	pushl  -0xc(%ebp)
80105689:	ff 75 f0             	pushl  -0x10(%ebp)
8010568c:	e8 5f 1c 00 00       	call   801072f0 <shm_open>
80105691:	83 c4 10             	add    $0x10,%esp
}
80105694:	c9                   	leave  
80105695:	c3                   	ret    
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
801056a0:	c9                   	leave  
    return -1;
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056a6:	c3                   	ret    
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_shm_close>:

int sys_shm_close(void) {
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
801056ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056bd:	50                   	push   %eax
801056be:	6a 00                	push   $0x0
801056c0:	e8 6b f2 ff ff       	call   80104930 <argint>
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	85 c0                	test   %eax,%eax
801056ca:	78 14                	js     801056e0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	ff 75 f4             	pushl  -0xc(%ebp)
801056d2:	e8 29 1c 00 00       	call   80107300 <shm_close>
801056d7:	83 c4 10             	add    $0x10,%esp
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e0:	c9                   	leave  
    return -1;
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e6:	c3                   	ret    
801056e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_fork>:

int
sys_fork(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
  return fork();
801056f4:	e9 67 e4 ff ff       	jmp    80103b60 <fork>
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exit>:
}

int
sys_exit(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	83 ec 08             	sub    $0x8,%esp
  exit();
8010570a:	e8 d1 e6 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
8010570f:	31 c0                	xor    %eax,%eax
80105711:	c9                   	leave  
80105712:	c3                   	ret    
80105713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <sys_wait>:

int
sys_wait(void)
{
80105720:	f3 0f 1e fb          	endbr32 
  return wait();
80105724:	e9 07 e9 ff ff       	jmp    80104030 <wait>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_kill>:
}

int
sys_kill(void)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
80105735:	89 e5                	mov    %esp,%ebp
80105737:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010573a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573d:	50                   	push   %eax
8010573e:	6a 00                	push   $0x0
80105740:	e8 eb f1 ff ff       	call   80104930 <argint>
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	85 c0                	test   %eax,%eax
8010574a:	78 14                	js     80105760 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	ff 75 f4             	pushl  -0xc(%ebp)
80105752:	e8 39 ea ff ff       	call   80104190 <kill>
80105757:	83 c4 10             	add    $0x10,%esp
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105760:	c9                   	leave  
    return -1;
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105766:	c3                   	ret    
80105767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576e:	66 90                	xchg   %ax,%ax

80105770 <sys_getpid>:

int
sys_getpid(void)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010577a:	e8 31 e2 ff ff       	call   801039b0 <myproc>
8010577f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105782:	c9                   	leave  
80105783:	c3                   	ret    
80105784:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105798:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010579b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579e:	50                   	push   %eax
8010579f:	6a 00                	push   $0x0
801057a1:	e8 8a f1 ff ff       	call   80104930 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 23                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057ad:	e8 fe e1 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
801057b2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ba:	e8 21 e3 ff ff       	call   80103ae0 <growproc>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 0a                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c6:	89 d8                	mov    %ebx,%eax
801057c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057cb:	c9                   	leave  
801057cc:	c3                   	ret    
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb ef                	jmp    801057c6 <sys_sbrk+0x36>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ee:	50                   	push   %eax
801057ef:	6a 00                	push   $0x0
801057f1:	e8 3a f1 ff ff       	call   80104930 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	0f 88 86 00 00 00    	js     80105887 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	68 80 4d 11 80       	push   $0x80114d80
80105809:	e8 02 ed ff ff       	call   80104510 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010580e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105811:	8b 1d c4 55 11 80    	mov    0x801155c4,%ebx
  while(ticks - ticks0 < n){
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 d2                	test   %edx,%edx
8010581c:	75 23                	jne    80105841 <sys_sleep+0x61>
8010581e:	eb 50                	jmp    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 80 4d 11 80       	push   $0x80114d80
80105828:	68 c4 55 11 80       	push   $0x801155c4
8010582d:	e8 3e e7 ff ff       	call   80103f70 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 c4 55 11 80       	mov    0x801155c4,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 6a e1 ff ff       	call   801039b0 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 80 4d 11 80       	push   $0x80114d80
80105855:	e8 e6 ed ff ff       	call   80104640 <release>
  }
  release(&tickslock);
  return 0;
}
8010585a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 80 4d 11 80       	push   $0x80114d80
80105878:	e8 c3 ed ff ff       	call   80104640 <release>
  return 0;
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
    return -1;
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb f4                	jmp    80105882 <sys_sleep+0xa2>
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	53                   	push   %ebx
80105898:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010589b:	68 80 4d 11 80       	push   $0x80114d80
801058a0:	e8 6b ec ff ff       	call   80104510 <acquire>
  xticks = ticks;
801058a5:	8b 1d c4 55 11 80    	mov    0x801155c4,%ebx
  release(&tickslock);
801058ab:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801058b2:	e8 89 ed ff ff       	call   80104640 <release>
  return xticks;
}
801058b7:	89 d8                	mov    %ebx,%eax
801058b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058bc:	c9                   	leave  
801058bd:	c3                   	ret    

801058be <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058be:	1e                   	push   %ds
  pushl %es
801058bf:	06                   	push   %es
  pushl %fs
801058c0:	0f a0                	push   %fs
  pushl %gs
801058c2:	0f a8                	push   %gs
  pushal
801058c4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058c5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058c9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058cb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058cd:	54                   	push   %esp
  call trap
801058ce:	e8 cd 00 00 00       	call   801059a0 <trap>
  addl $4, %esp
801058d3:	83 c4 04             	add    $0x4,%esp

801058d6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058d6:	61                   	popa   
  popl %gs
801058d7:	0f a9                	pop    %gs
  popl %fs
801058d9:	0f a1                	pop    %fs
  popl %es
801058db:	07                   	pop    %es
  popl %ds
801058dc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058dd:	83 c4 08             	add    $0x8,%esp
  iret
801058e0:	cf                   	iret   
801058e1:	66 90                	xchg   %ax,%ax
801058e3:	66 90                	xchg   %ax,%ax
801058e5:	66 90                	xchg   %ax,%ax
801058e7:	66 90                	xchg   %ax,%ax
801058e9:	66 90                	xchg   %ax,%ax
801058eb:	66 90                	xchg   %ax,%ax
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
uint sp;
pde_t *pgdir;

void
tvinit(void)
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058f5:	31 c0                	xor    %eax,%eax
{
801058f7:	89 e5                	mov    %esp,%ebp
801058f9:	83 ec 08             	sub    $0x8,%esp
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105900:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105907:	c7 04 c5 c2 4d 11 80 	movl   $0x8e000008,-0x7feeb23e(,%eax,8)
8010590e:	08 00 00 8e 
80105912:	66 89 14 c5 c0 4d 11 	mov    %dx,-0x7feeb240(,%eax,8)
80105919:	80 
8010591a:	c1 ea 10             	shr    $0x10,%edx
8010591d:	66 89 14 c5 c6 4d 11 	mov    %dx,-0x7feeb23a(,%eax,8)
80105924:	80 
  for(i = 0; i < 256; i++)
80105925:	83 c0 01             	add    $0x1,%eax
80105928:	3d 00 01 00 00       	cmp    $0x100,%eax
8010592d:	75 d1                	jne    80105900 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010592f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105932:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105937:	c7 05 c2 4f 11 80 08 	movl   $0xef000008,0x80114fc2
8010593e:	00 00 ef 
  initlock(&tickslock, "time");
80105941:	68 a1 7a 10 80       	push   $0x80107aa1
80105946:	68 80 4d 11 80       	push   $0x80114d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010594b:	66 a3 c0 4f 11 80    	mov    %ax,0x80114fc0
80105951:	c1 e8 10             	shr    $0x10,%eax
80105954:	66 a3 c6 4f 11 80    	mov    %ax,0x80114fc6
  initlock(&tickslock, "time");
8010595a:	e8 a1 ea ff ff       	call   80104400 <initlock>
}
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <idtinit>:

void
idtinit(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
  pd[0] = size-1;
80105975:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010597a:	89 e5                	mov    %esp,%ebp
8010597c:	83 ec 10             	sub    $0x10,%esp
8010597f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105983:	b8 c0 4d 11 80       	mov    $0x80114dc0,%eax
80105988:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010598c:	c1 e8 10             	shr    $0x10,%eax
8010598f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105993:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105996:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105999:	c9                   	leave  
8010599a:	c3                   	ret    
8010599b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop

801059a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059a0:	f3 0f 1e fb          	endbr32 
801059a4:	55                   	push   %ebp
801059a5:	89 e5                	mov    %esp,%ebp
801059a7:	57                   	push   %edi
801059a8:	56                   	push   %esi
801059a9:	53                   	push   %ebx
801059aa:	83 ec 1c             	sub    $0x1c,%esp
801059ad:	8b 5d 08             	mov    0x8(%ebp),%ebx

  //cs 153 lab 2
  //cprintf("\n\n//////////////////////////////////////////////////\n");
  //cprintf("Enter trap() in trap.c...\n\n");

  if(tf->trapno == T_SYSCALL){
801059b0:	8b 43 30             	mov    0x30(%ebx),%eax
801059b3:	83 f8 40             	cmp    $0x40,%eax
801059b6:	0f 84 1c 02 00 00    	je     80105bd8 <trap+0x238>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059bc:	83 e8 0e             	sub    $0xe,%eax
801059bf:	83 f8 31             	cmp    $0x31,%eax
801059c2:	77 08                	ja     801059cc <trap+0x2c>
801059c4:	3e ff 24 85 7c 7b 10 	notrack jmp *-0x7fef8484(,%eax,4)
801059cb:	80 
  //////////////////////
  

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059cc:	e8 df df ff ff       	call   801039b0 <myproc>
801059d1:	8b 7b 38             	mov    0x38(%ebx),%edi
801059d4:	85 c0                	test   %eax,%eax
801059d6:	0f 84 4b 02 00 00    	je     80105c27 <trap+0x287>
801059dc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801059e0:	0f 84 41 02 00 00    	je     80105c27 <trap+0x287>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059e6:	0f 20 d1             	mov    %cr2,%ecx
801059e9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059ec:	e8 9f df ff ff       	call   80103990 <cpuid>
801059f1:	8b 73 30             	mov    0x30(%ebx),%esi
801059f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059f7:	8b 43 34             	mov    0x34(%ebx),%eax
801059fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801059fd:	e8 ae df ff ff       	call   801039b0 <myproc>
80105a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a05:	e8 a6 df ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a0a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a10:	51                   	push   %ecx
80105a11:	57                   	push   %edi
80105a12:	52                   	push   %edx
80105a13:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a16:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a17:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a1a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1d:	56                   	push   %esi
80105a1e:	ff 70 10             	pushl  0x10(%eax)
80105a21:	68 38 7b 10 80       	push   $0x80107b38
80105a26:	e8 85 ac ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a2b:	83 c4 20             	add    $0x20,%esp
80105a2e:	e8 7d df ff ff       	call   801039b0 <myproc>
80105a33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a3a:	e8 71 df ff ff       	call   801039b0 <myproc>
80105a3f:	85 c0                	test   %eax,%eax
80105a41:	74 1d                	je     80105a60 <trap+0xc0>
80105a43:	e8 68 df ff ff       	call   801039b0 <myproc>
80105a48:	8b 50 24             	mov    0x24(%eax),%edx
80105a4b:	85 d2                	test   %edx,%edx
80105a4d:	74 11                	je     80105a60 <trap+0xc0>
80105a4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a53:	83 e0 03             	and    $0x3,%eax
80105a56:	66 83 f8 03          	cmp    $0x3,%ax
80105a5a:	0f 84 b0 01 00 00    	je     80105c10 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a60:	e8 4b df ff ff       	call   801039b0 <myproc>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	74 0f                	je     80105a78 <trap+0xd8>
80105a69:	e8 42 df ff ff       	call   801039b0 <myproc>
80105a6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a72:	0f 84 48 01 00 00    	je     80105bc0 <trap+0x220>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a78:	e8 33 df ff ff       	call   801039b0 <myproc>
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	74 1d                	je     80105a9e <trap+0xfe>
80105a81:	e8 2a df ff ff       	call   801039b0 <myproc>
80105a86:	8b 40 24             	mov    0x24(%eax),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	74 11                	je     80105a9e <trap+0xfe>
80105a8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a91:	83 e0 03             	and    $0x3,%eax
80105a94:	66 83 f8 03          	cmp    $0x3,%ax
80105a98:	0f 84 63 01 00 00    	je     80105c01 <trap+0x261>
    exit();
}
80105a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa1:	5b                   	pop    %ebx
80105aa2:	5e                   	pop    %esi
80105aa3:	5f                   	pop    %edi
80105aa4:	5d                   	pop    %ebp
80105aa5:	c3                   	ret    
    ideintr();
80105aa6:	e8 75 c7 ff ff       	call   80102220 <ideintr>
    lapiceoi();
80105aab:	e8 50 ce ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ab0:	e8 fb de ff ff       	call   801039b0 <myproc>
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	75 8a                	jne    80105a43 <trap+0xa3>
80105ab9:	eb a5                	jmp    80105a60 <trap+0xc0>
    sp = tf->esp; // gets the stack pointer from the trap frame    
80105abb:	8b 73 44             	mov    0x44(%ebx),%esi
80105abe:	89 35 c0 55 11 80    	mov    %esi,0x801155c0
80105ac4:	0f 20 d0             	mov    %cr2,%eax
    if( (rcr2() < sp) && (rcr2() > (sp-PGSIZE) ) ) {
80105ac7:	39 c6                	cmp    %eax,%esi
80105ac9:	0f 86 6b ff ff ff    	jbe    80105a3a <trap+0x9a>
80105acf:	0f 20 d0             	mov    %cr2,%eax
80105ad2:	8d be 00 f0 ff ff    	lea    -0x1000(%esi),%edi
80105ad8:	39 c7                	cmp    %eax,%edi
80105ada:	0f 83 5a ff ff ff    	jae    80105a3a <trap+0x9a>
      if((allocuvm(myproc()->pgdir, sp - PGSIZE, sp)) == 0) {
80105ae0:	e8 cb de ff ff       	call   801039b0 <myproc>
80105ae5:	83 ec 04             	sub    $0x4,%esp
80105ae8:	56                   	push   %esi
80105ae9:	57                   	push   %edi
80105aea:	ff 70 04             	pushl  0x4(%eax)
80105aed:	e8 2e 12 00 00       	call   80106d20 <allocuvm>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	0f 85 3d ff ff ff    	jne    80105a3a <trap+0x9a>
        cprintf("\n\nno more memory to allocate, exiting program...\n\n");
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 d0 7a 10 80       	push   $0x80107ad0
80105b05:	e8 a6 ab ff ff       	call   801006b0 <cprintf>
        exit();
80105b0a:	e8 d1 e2 ff ff       	call   80103de0 <exit>
80105b0f:	83 c4 10             	add    $0x10,%esp
80105b12:	e9 23 ff ff ff       	jmp    80105a3a <trap+0x9a>
    if(cpuid() == 0){
80105b17:	e8 74 de ff ff       	call   80103990 <cpuid>
80105b1c:	85 c0                	test   %eax,%eax
80105b1e:	75 8b                	jne    80105aab <trap+0x10b>
      acquire(&tickslock);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	68 80 4d 11 80       	push   $0x80114d80
80105b28:	e8 e3 e9 ff ff       	call   80104510 <acquire>
      wakeup(&ticks);
80105b2d:	c7 04 24 c4 55 11 80 	movl   $0x801155c4,(%esp)
      ticks++;
80105b34:	83 05 c4 55 11 80 01 	addl   $0x1,0x801155c4
      wakeup(&ticks);
80105b3b:	e8 f0 e5 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
80105b40:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80105b47:	e8 f4 ea ff ff       	call   80104640 <release>
80105b4c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b4f:	e9 57 ff ff ff       	jmp    80105aab <trap+0x10b>
    kbdintr();
80105b54:	e8 67 cc ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105b59:	e8 a2 cd ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5e:	e8 4d de ff ff       	call   801039b0 <myproc>
80105b63:	85 c0                	test   %eax,%eax
80105b65:	0f 85 d8 fe ff ff    	jne    80105a43 <trap+0xa3>
80105b6b:	e9 f0 fe ff ff       	jmp    80105a60 <trap+0xc0>
    uartintr();
80105b70:	e8 4b 02 00 00       	call   80105dc0 <uartintr>
    lapiceoi();
80105b75:	e8 86 cd ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7a:	e8 31 de ff ff       	call   801039b0 <myproc>
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	0f 85 bc fe ff ff    	jne    80105a43 <trap+0xa3>
80105b87:	e9 d4 fe ff ff       	jmp    80105a60 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b8c:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b8f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b93:	e8 f8 dd ff ff       	call   80103990 <cpuid>
80105b98:	57                   	push   %edi
80105b99:	56                   	push   %esi
80105b9a:	50                   	push   %eax
80105b9b:	68 ac 7a 10 80       	push   $0x80107aac
80105ba0:	e8 0b ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105ba5:	e8 56 cd ff ff       	call   80102900 <lapiceoi>
    break;
80105baa:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bad:	e8 fe dd ff ff       	call   801039b0 <myproc>
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	0f 85 89 fe ff ff    	jne    80105a43 <trap+0xa3>
80105bba:	e9 a1 fe ff ff       	jmp    80105a60 <trap+0xc0>
80105bbf:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80105bc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105bc4:	0f 85 ae fe ff ff    	jne    80105a78 <trap+0xd8>
    yield();
80105bca:	e8 51 e3 ff ff       	call   80103f20 <yield>
80105bcf:	e9 a4 fe ff ff       	jmp    80105a78 <trap+0xd8>
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105bd8:	e8 d3 dd ff ff       	call   801039b0 <myproc>
80105bdd:	8b 70 24             	mov    0x24(%eax),%esi
80105be0:	85 f6                	test   %esi,%esi
80105be2:	75 3c                	jne    80105c20 <trap+0x280>
    myproc()->tf = tf;
80105be4:	e8 c7 dd ff ff       	call   801039b0 <myproc>
80105be9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105bec:	e8 ff ed ff ff       	call   801049f0 <syscall>
    if(myproc()->killed)
80105bf1:	e8 ba dd ff ff       	call   801039b0 <myproc>
80105bf6:	8b 48 24             	mov    0x24(%eax),%ecx
80105bf9:	85 c9                	test   %ecx,%ecx
80105bfb:	0f 84 9d fe ff ff    	je     80105a9e <trap+0xfe>
}
80105c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c04:	5b                   	pop    %ebx
80105c05:	5e                   	pop    %esi
80105c06:	5f                   	pop    %edi
80105c07:	5d                   	pop    %ebp
      exit();
80105c08:	e9 d3 e1 ff ff       	jmp    80103de0 <exit>
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105c10:	e8 cb e1 ff ff       	call   80103de0 <exit>
80105c15:	e9 46 fe ff ff       	jmp    80105a60 <trap+0xc0>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c20:	e8 bb e1 ff ff       	call   80103de0 <exit>
80105c25:	eb bd                	jmp    80105be4 <trap+0x244>
80105c27:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c2a:	e8 61 dd ff ff       	call   80103990 <cpuid>
80105c2f:	83 ec 0c             	sub    $0xc,%esp
80105c32:	56                   	push   %esi
80105c33:	57                   	push   %edi
80105c34:	50                   	push   %eax
80105c35:	ff 73 30             	pushl  0x30(%ebx)
80105c38:	68 04 7b 10 80       	push   $0x80107b04
80105c3d:	e8 6e aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c42:	83 c4 14             	add    $0x14,%esp
80105c45:	68 a6 7a 10 80       	push   $0x80107aa6
80105c4a:	e8 41 a7 ff ff       	call   80100390 <panic>
80105c4f:	90                   	nop

80105c50 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105c54:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	74 1b                	je     80105c78 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c5d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c62:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c63:	a8 01                	test   $0x1,%al
80105c65:	74 11                	je     80105c78 <uartgetc+0x28>
80105c67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c6c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c6d:	0f b6 c0             	movzbl %al,%eax
80105c70:	c3                   	ret    
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c7d:	c3                   	ret    
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <uartputc.part.0>:
uartputc(int c)
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	89 c7                	mov    %eax,%edi
80105c86:	56                   	push   %esi
80105c87:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c8c:	53                   	push   %ebx
80105c8d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c92:	83 ec 0c             	sub    $0xc,%esp
80105c95:	eb 1b                	jmp    80105cb2 <uartputc.part.0+0x32>
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	6a 0a                	push   $0xa
80105ca5:	e8 76 cc ff ff       	call   80102920 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105caa:	83 c4 10             	add    $0x10,%esp
80105cad:	83 eb 01             	sub    $0x1,%ebx
80105cb0:	74 07                	je     80105cb9 <uartputc.part.0+0x39>
80105cb2:	89 f2                	mov    %esi,%edx
80105cb4:	ec                   	in     (%dx),%al
80105cb5:	a8 20                	test   $0x20,%al
80105cb7:	74 e7                	je     80105ca0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cbe:	89 f8                	mov    %edi,%eax
80105cc0:	ee                   	out    %al,(%dx)
}
80105cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc4:	5b                   	pop    %ebx
80105cc5:	5e                   	pop    %esi
80105cc6:	5f                   	pop    %edi
80105cc7:	5d                   	pop    %ebp
80105cc8:	c3                   	ret    
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <uartinit>:
{
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	31 c9                	xor    %ecx,%ecx
80105cd7:	89 c8                	mov    %ecx,%eax
80105cd9:	89 e5                	mov    %esp,%ebp
80105cdb:	57                   	push   %edi
80105cdc:	56                   	push   %esi
80105cdd:	53                   	push   %ebx
80105cde:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105ce3:	89 da                	mov    %ebx,%edx
80105ce5:	83 ec 0c             	sub    $0xc,%esp
80105ce8:	ee                   	out    %al,(%dx)
80105ce9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105cee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cf3:	89 fa                	mov    %edi,%edx
80105cf5:	ee                   	out    %al,(%dx)
80105cf6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cfb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d00:	ee                   	out    %al,(%dx)
80105d01:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d06:	89 c8                	mov    %ecx,%eax
80105d08:	89 f2                	mov    %esi,%edx
80105d0a:	ee                   	out    %al,(%dx)
80105d0b:	b8 03 00 00 00       	mov    $0x3,%eax
80105d10:	89 fa                	mov    %edi,%edx
80105d12:	ee                   	out    %al,(%dx)
80105d13:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d18:	89 c8                	mov    %ecx,%eax
80105d1a:	ee                   	out    %al,(%dx)
80105d1b:	b8 01 00 00 00       	mov    $0x1,%eax
80105d20:	89 f2                	mov    %esi,%edx
80105d22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d23:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d28:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d29:	3c ff                	cmp    $0xff,%al
80105d2b:	74 52                	je     80105d7f <uartinit+0xaf>
  uart = 1;
80105d2d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d34:	00 00 00 
80105d37:	89 da                	mov    %ebx,%edx
80105d39:	ec                   	in     (%dx),%al
80105d3a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d40:	83 ec 08             	sub    $0x8,%esp
80105d43:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105d48:	bb 44 7c 10 80       	mov    $0x80107c44,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d4d:	6a 00                	push   $0x0
80105d4f:	6a 04                	push   $0x4
80105d51:	e8 1a c7 ff ff       	call   80102470 <ioapicenable>
80105d56:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d59:	b8 78 00 00 00       	mov    $0x78,%eax
80105d5e:	eb 04                	jmp    80105d64 <uartinit+0x94>
80105d60:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105d64:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d6a:	85 d2                	test   %edx,%edx
80105d6c:	74 08                	je     80105d76 <uartinit+0xa6>
    uartputc(*p);
80105d6e:	0f be c0             	movsbl %al,%eax
80105d71:	e8 0a ff ff ff       	call   80105c80 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105d76:	89 f0                	mov    %esi,%eax
80105d78:	83 c3 01             	add    $0x1,%ebx
80105d7b:	84 c0                	test   %al,%al
80105d7d:	75 e1                	jne    80105d60 <uartinit+0x90>
}
80105d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d82:	5b                   	pop    %ebx
80105d83:	5e                   	pop    %esi
80105d84:	5f                   	pop    %edi
80105d85:	5d                   	pop    %ebp
80105d86:	c3                   	ret    
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <uartputc>:
{
80105d90:	f3 0f 1e fb          	endbr32 
80105d94:	55                   	push   %ebp
  if(!uart)
80105d95:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d9b:	89 e5                	mov    %esp,%ebp
80105d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105da0:	85 d2                	test   %edx,%edx
80105da2:	74 0c                	je     80105db0 <uartputc+0x20>
}
80105da4:	5d                   	pop    %ebp
80105da5:	e9 d6 fe ff ff       	jmp    80105c80 <uartputc.part.0>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105db0:	5d                   	pop    %ebp
80105db1:	c3                   	ret    
80105db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <uartintr>:

void
uartintr(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105dca:	68 50 5c 10 80       	push   $0x80105c50
80105dcf:	e8 8c aa ff ff       	call   80100860 <consoleintr>
}
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	c9                   	leave  
80105dd8:	c3                   	ret    

80105dd9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $0
80105ddb:	6a 00                	push   $0x0
  jmp alltraps
80105ddd:	e9 dc fa ff ff       	jmp    801058be <alltraps>

80105de2 <vector1>:
.globl vector1
vector1:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $1
80105de4:	6a 01                	push   $0x1
  jmp alltraps
80105de6:	e9 d3 fa ff ff       	jmp    801058be <alltraps>

80105deb <vector2>:
.globl vector2
vector2:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $2
80105ded:	6a 02                	push   $0x2
  jmp alltraps
80105def:	e9 ca fa ff ff       	jmp    801058be <alltraps>

80105df4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $3
80105df6:	6a 03                	push   $0x3
  jmp alltraps
80105df8:	e9 c1 fa ff ff       	jmp    801058be <alltraps>

80105dfd <vector4>:
.globl vector4
vector4:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $4
80105dff:	6a 04                	push   $0x4
  jmp alltraps
80105e01:	e9 b8 fa ff ff       	jmp    801058be <alltraps>

80105e06 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $5
80105e08:	6a 05                	push   $0x5
  jmp alltraps
80105e0a:	e9 af fa ff ff       	jmp    801058be <alltraps>

80105e0f <vector6>:
.globl vector6
vector6:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $6
80105e11:	6a 06                	push   $0x6
  jmp alltraps
80105e13:	e9 a6 fa ff ff       	jmp    801058be <alltraps>

80105e18 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $7
80105e1a:	6a 07                	push   $0x7
  jmp alltraps
80105e1c:	e9 9d fa ff ff       	jmp    801058be <alltraps>

80105e21 <vector8>:
.globl vector8
vector8:
  pushl $8
80105e21:	6a 08                	push   $0x8
  jmp alltraps
80105e23:	e9 96 fa ff ff       	jmp    801058be <alltraps>

80105e28 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $9
80105e2a:	6a 09                	push   $0x9
  jmp alltraps
80105e2c:	e9 8d fa ff ff       	jmp    801058be <alltraps>

80105e31 <vector10>:
.globl vector10
vector10:
  pushl $10
80105e31:	6a 0a                	push   $0xa
  jmp alltraps
80105e33:	e9 86 fa ff ff       	jmp    801058be <alltraps>

80105e38 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e38:	6a 0b                	push   $0xb
  jmp alltraps
80105e3a:	e9 7f fa ff ff       	jmp    801058be <alltraps>

80105e3f <vector12>:
.globl vector12
vector12:
  pushl $12
80105e3f:	6a 0c                	push   $0xc
  jmp alltraps
80105e41:	e9 78 fa ff ff       	jmp    801058be <alltraps>

80105e46 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e46:	6a 0d                	push   $0xd
  jmp alltraps
80105e48:	e9 71 fa ff ff       	jmp    801058be <alltraps>

80105e4d <vector14>:
.globl vector14
vector14:
  pushl $14
80105e4d:	6a 0e                	push   $0xe
  jmp alltraps
80105e4f:	e9 6a fa ff ff       	jmp    801058be <alltraps>

80105e54 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $15
80105e56:	6a 0f                	push   $0xf
  jmp alltraps
80105e58:	e9 61 fa ff ff       	jmp    801058be <alltraps>

80105e5d <vector16>:
.globl vector16
vector16:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $16
80105e5f:	6a 10                	push   $0x10
  jmp alltraps
80105e61:	e9 58 fa ff ff       	jmp    801058be <alltraps>

80105e66 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e66:	6a 11                	push   $0x11
  jmp alltraps
80105e68:	e9 51 fa ff ff       	jmp    801058be <alltraps>

80105e6d <vector18>:
.globl vector18
vector18:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $18
80105e6f:	6a 12                	push   $0x12
  jmp alltraps
80105e71:	e9 48 fa ff ff       	jmp    801058be <alltraps>

80105e76 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $19
80105e78:	6a 13                	push   $0x13
  jmp alltraps
80105e7a:	e9 3f fa ff ff       	jmp    801058be <alltraps>

80105e7f <vector20>:
.globl vector20
vector20:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $20
80105e81:	6a 14                	push   $0x14
  jmp alltraps
80105e83:	e9 36 fa ff ff       	jmp    801058be <alltraps>

80105e88 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $21
80105e8a:	6a 15                	push   $0x15
  jmp alltraps
80105e8c:	e9 2d fa ff ff       	jmp    801058be <alltraps>

80105e91 <vector22>:
.globl vector22
vector22:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $22
80105e93:	6a 16                	push   $0x16
  jmp alltraps
80105e95:	e9 24 fa ff ff       	jmp    801058be <alltraps>

80105e9a <vector23>:
.globl vector23
vector23:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $23
80105e9c:	6a 17                	push   $0x17
  jmp alltraps
80105e9e:	e9 1b fa ff ff       	jmp    801058be <alltraps>

80105ea3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $24
80105ea5:	6a 18                	push   $0x18
  jmp alltraps
80105ea7:	e9 12 fa ff ff       	jmp    801058be <alltraps>

80105eac <vector25>:
.globl vector25
vector25:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $25
80105eae:	6a 19                	push   $0x19
  jmp alltraps
80105eb0:	e9 09 fa ff ff       	jmp    801058be <alltraps>

80105eb5 <vector26>:
.globl vector26
vector26:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $26
80105eb7:	6a 1a                	push   $0x1a
  jmp alltraps
80105eb9:	e9 00 fa ff ff       	jmp    801058be <alltraps>

80105ebe <vector27>:
.globl vector27
vector27:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $27
80105ec0:	6a 1b                	push   $0x1b
  jmp alltraps
80105ec2:	e9 f7 f9 ff ff       	jmp    801058be <alltraps>

80105ec7 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $28
80105ec9:	6a 1c                	push   $0x1c
  jmp alltraps
80105ecb:	e9 ee f9 ff ff       	jmp    801058be <alltraps>

80105ed0 <vector29>:
.globl vector29
vector29:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $29
80105ed2:	6a 1d                	push   $0x1d
  jmp alltraps
80105ed4:	e9 e5 f9 ff ff       	jmp    801058be <alltraps>

80105ed9 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $30
80105edb:	6a 1e                	push   $0x1e
  jmp alltraps
80105edd:	e9 dc f9 ff ff       	jmp    801058be <alltraps>

80105ee2 <vector31>:
.globl vector31
vector31:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $31
80105ee4:	6a 1f                	push   $0x1f
  jmp alltraps
80105ee6:	e9 d3 f9 ff ff       	jmp    801058be <alltraps>

80105eeb <vector32>:
.globl vector32
vector32:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $32
80105eed:	6a 20                	push   $0x20
  jmp alltraps
80105eef:	e9 ca f9 ff ff       	jmp    801058be <alltraps>

80105ef4 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $33
80105ef6:	6a 21                	push   $0x21
  jmp alltraps
80105ef8:	e9 c1 f9 ff ff       	jmp    801058be <alltraps>

80105efd <vector34>:
.globl vector34
vector34:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $34
80105eff:	6a 22                	push   $0x22
  jmp alltraps
80105f01:	e9 b8 f9 ff ff       	jmp    801058be <alltraps>

80105f06 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $35
80105f08:	6a 23                	push   $0x23
  jmp alltraps
80105f0a:	e9 af f9 ff ff       	jmp    801058be <alltraps>

80105f0f <vector36>:
.globl vector36
vector36:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $36
80105f11:	6a 24                	push   $0x24
  jmp alltraps
80105f13:	e9 a6 f9 ff ff       	jmp    801058be <alltraps>

80105f18 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $37
80105f1a:	6a 25                	push   $0x25
  jmp alltraps
80105f1c:	e9 9d f9 ff ff       	jmp    801058be <alltraps>

80105f21 <vector38>:
.globl vector38
vector38:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $38
80105f23:	6a 26                	push   $0x26
  jmp alltraps
80105f25:	e9 94 f9 ff ff       	jmp    801058be <alltraps>

80105f2a <vector39>:
.globl vector39
vector39:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $39
80105f2c:	6a 27                	push   $0x27
  jmp alltraps
80105f2e:	e9 8b f9 ff ff       	jmp    801058be <alltraps>

80105f33 <vector40>:
.globl vector40
vector40:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $40
80105f35:	6a 28                	push   $0x28
  jmp alltraps
80105f37:	e9 82 f9 ff ff       	jmp    801058be <alltraps>

80105f3c <vector41>:
.globl vector41
vector41:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $41
80105f3e:	6a 29                	push   $0x29
  jmp alltraps
80105f40:	e9 79 f9 ff ff       	jmp    801058be <alltraps>

80105f45 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $42
80105f47:	6a 2a                	push   $0x2a
  jmp alltraps
80105f49:	e9 70 f9 ff ff       	jmp    801058be <alltraps>

80105f4e <vector43>:
.globl vector43
vector43:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $43
80105f50:	6a 2b                	push   $0x2b
  jmp alltraps
80105f52:	e9 67 f9 ff ff       	jmp    801058be <alltraps>

80105f57 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $44
80105f59:	6a 2c                	push   $0x2c
  jmp alltraps
80105f5b:	e9 5e f9 ff ff       	jmp    801058be <alltraps>

80105f60 <vector45>:
.globl vector45
vector45:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $45
80105f62:	6a 2d                	push   $0x2d
  jmp alltraps
80105f64:	e9 55 f9 ff ff       	jmp    801058be <alltraps>

80105f69 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $46
80105f6b:	6a 2e                	push   $0x2e
  jmp alltraps
80105f6d:	e9 4c f9 ff ff       	jmp    801058be <alltraps>

80105f72 <vector47>:
.globl vector47
vector47:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $47
80105f74:	6a 2f                	push   $0x2f
  jmp alltraps
80105f76:	e9 43 f9 ff ff       	jmp    801058be <alltraps>

80105f7b <vector48>:
.globl vector48
vector48:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $48
80105f7d:	6a 30                	push   $0x30
  jmp alltraps
80105f7f:	e9 3a f9 ff ff       	jmp    801058be <alltraps>

80105f84 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $49
80105f86:	6a 31                	push   $0x31
  jmp alltraps
80105f88:	e9 31 f9 ff ff       	jmp    801058be <alltraps>

80105f8d <vector50>:
.globl vector50
vector50:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $50
80105f8f:	6a 32                	push   $0x32
  jmp alltraps
80105f91:	e9 28 f9 ff ff       	jmp    801058be <alltraps>

80105f96 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $51
80105f98:	6a 33                	push   $0x33
  jmp alltraps
80105f9a:	e9 1f f9 ff ff       	jmp    801058be <alltraps>

80105f9f <vector52>:
.globl vector52
vector52:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $52
80105fa1:	6a 34                	push   $0x34
  jmp alltraps
80105fa3:	e9 16 f9 ff ff       	jmp    801058be <alltraps>

80105fa8 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $53
80105faa:	6a 35                	push   $0x35
  jmp alltraps
80105fac:	e9 0d f9 ff ff       	jmp    801058be <alltraps>

80105fb1 <vector54>:
.globl vector54
vector54:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $54
80105fb3:	6a 36                	push   $0x36
  jmp alltraps
80105fb5:	e9 04 f9 ff ff       	jmp    801058be <alltraps>

80105fba <vector55>:
.globl vector55
vector55:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $55
80105fbc:	6a 37                	push   $0x37
  jmp alltraps
80105fbe:	e9 fb f8 ff ff       	jmp    801058be <alltraps>

80105fc3 <vector56>:
.globl vector56
vector56:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $56
80105fc5:	6a 38                	push   $0x38
  jmp alltraps
80105fc7:	e9 f2 f8 ff ff       	jmp    801058be <alltraps>

80105fcc <vector57>:
.globl vector57
vector57:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $57
80105fce:	6a 39                	push   $0x39
  jmp alltraps
80105fd0:	e9 e9 f8 ff ff       	jmp    801058be <alltraps>

80105fd5 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $58
80105fd7:	6a 3a                	push   $0x3a
  jmp alltraps
80105fd9:	e9 e0 f8 ff ff       	jmp    801058be <alltraps>

80105fde <vector59>:
.globl vector59
vector59:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $59
80105fe0:	6a 3b                	push   $0x3b
  jmp alltraps
80105fe2:	e9 d7 f8 ff ff       	jmp    801058be <alltraps>

80105fe7 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $60
80105fe9:	6a 3c                	push   $0x3c
  jmp alltraps
80105feb:	e9 ce f8 ff ff       	jmp    801058be <alltraps>

80105ff0 <vector61>:
.globl vector61
vector61:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $61
80105ff2:	6a 3d                	push   $0x3d
  jmp alltraps
80105ff4:	e9 c5 f8 ff ff       	jmp    801058be <alltraps>

80105ff9 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $62
80105ffb:	6a 3e                	push   $0x3e
  jmp alltraps
80105ffd:	e9 bc f8 ff ff       	jmp    801058be <alltraps>

80106002 <vector63>:
.globl vector63
vector63:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $63
80106004:	6a 3f                	push   $0x3f
  jmp alltraps
80106006:	e9 b3 f8 ff ff       	jmp    801058be <alltraps>

8010600b <vector64>:
.globl vector64
vector64:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $64
8010600d:	6a 40                	push   $0x40
  jmp alltraps
8010600f:	e9 aa f8 ff ff       	jmp    801058be <alltraps>

80106014 <vector65>:
.globl vector65
vector65:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $65
80106016:	6a 41                	push   $0x41
  jmp alltraps
80106018:	e9 a1 f8 ff ff       	jmp    801058be <alltraps>

8010601d <vector66>:
.globl vector66
vector66:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $66
8010601f:	6a 42                	push   $0x42
  jmp alltraps
80106021:	e9 98 f8 ff ff       	jmp    801058be <alltraps>

80106026 <vector67>:
.globl vector67
vector67:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $67
80106028:	6a 43                	push   $0x43
  jmp alltraps
8010602a:	e9 8f f8 ff ff       	jmp    801058be <alltraps>

8010602f <vector68>:
.globl vector68
vector68:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $68
80106031:	6a 44                	push   $0x44
  jmp alltraps
80106033:	e9 86 f8 ff ff       	jmp    801058be <alltraps>

80106038 <vector69>:
.globl vector69
vector69:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $69
8010603a:	6a 45                	push   $0x45
  jmp alltraps
8010603c:	e9 7d f8 ff ff       	jmp    801058be <alltraps>

80106041 <vector70>:
.globl vector70
vector70:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $70
80106043:	6a 46                	push   $0x46
  jmp alltraps
80106045:	e9 74 f8 ff ff       	jmp    801058be <alltraps>

8010604a <vector71>:
.globl vector71
vector71:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $71
8010604c:	6a 47                	push   $0x47
  jmp alltraps
8010604e:	e9 6b f8 ff ff       	jmp    801058be <alltraps>

80106053 <vector72>:
.globl vector72
vector72:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $72
80106055:	6a 48                	push   $0x48
  jmp alltraps
80106057:	e9 62 f8 ff ff       	jmp    801058be <alltraps>

8010605c <vector73>:
.globl vector73
vector73:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $73
8010605e:	6a 49                	push   $0x49
  jmp alltraps
80106060:	e9 59 f8 ff ff       	jmp    801058be <alltraps>

80106065 <vector74>:
.globl vector74
vector74:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $74
80106067:	6a 4a                	push   $0x4a
  jmp alltraps
80106069:	e9 50 f8 ff ff       	jmp    801058be <alltraps>

8010606e <vector75>:
.globl vector75
vector75:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $75
80106070:	6a 4b                	push   $0x4b
  jmp alltraps
80106072:	e9 47 f8 ff ff       	jmp    801058be <alltraps>

80106077 <vector76>:
.globl vector76
vector76:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $76
80106079:	6a 4c                	push   $0x4c
  jmp alltraps
8010607b:	e9 3e f8 ff ff       	jmp    801058be <alltraps>

80106080 <vector77>:
.globl vector77
vector77:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $77
80106082:	6a 4d                	push   $0x4d
  jmp alltraps
80106084:	e9 35 f8 ff ff       	jmp    801058be <alltraps>

80106089 <vector78>:
.globl vector78
vector78:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $78
8010608b:	6a 4e                	push   $0x4e
  jmp alltraps
8010608d:	e9 2c f8 ff ff       	jmp    801058be <alltraps>

80106092 <vector79>:
.globl vector79
vector79:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $79
80106094:	6a 4f                	push   $0x4f
  jmp alltraps
80106096:	e9 23 f8 ff ff       	jmp    801058be <alltraps>

8010609b <vector80>:
.globl vector80
vector80:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $80
8010609d:	6a 50                	push   $0x50
  jmp alltraps
8010609f:	e9 1a f8 ff ff       	jmp    801058be <alltraps>

801060a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $81
801060a6:	6a 51                	push   $0x51
  jmp alltraps
801060a8:	e9 11 f8 ff ff       	jmp    801058be <alltraps>

801060ad <vector82>:
.globl vector82
vector82:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $82
801060af:	6a 52                	push   $0x52
  jmp alltraps
801060b1:	e9 08 f8 ff ff       	jmp    801058be <alltraps>

801060b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $83
801060b8:	6a 53                	push   $0x53
  jmp alltraps
801060ba:	e9 ff f7 ff ff       	jmp    801058be <alltraps>

801060bf <vector84>:
.globl vector84
vector84:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $84
801060c1:	6a 54                	push   $0x54
  jmp alltraps
801060c3:	e9 f6 f7 ff ff       	jmp    801058be <alltraps>

801060c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $85
801060ca:	6a 55                	push   $0x55
  jmp alltraps
801060cc:	e9 ed f7 ff ff       	jmp    801058be <alltraps>

801060d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $86
801060d3:	6a 56                	push   $0x56
  jmp alltraps
801060d5:	e9 e4 f7 ff ff       	jmp    801058be <alltraps>

801060da <vector87>:
.globl vector87
vector87:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $87
801060dc:	6a 57                	push   $0x57
  jmp alltraps
801060de:	e9 db f7 ff ff       	jmp    801058be <alltraps>

801060e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $88
801060e5:	6a 58                	push   $0x58
  jmp alltraps
801060e7:	e9 d2 f7 ff ff       	jmp    801058be <alltraps>

801060ec <vector89>:
.globl vector89
vector89:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $89
801060ee:	6a 59                	push   $0x59
  jmp alltraps
801060f0:	e9 c9 f7 ff ff       	jmp    801058be <alltraps>

801060f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $90
801060f7:	6a 5a                	push   $0x5a
  jmp alltraps
801060f9:	e9 c0 f7 ff ff       	jmp    801058be <alltraps>

801060fe <vector91>:
.globl vector91
vector91:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $91
80106100:	6a 5b                	push   $0x5b
  jmp alltraps
80106102:	e9 b7 f7 ff ff       	jmp    801058be <alltraps>

80106107 <vector92>:
.globl vector92
vector92:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $92
80106109:	6a 5c                	push   $0x5c
  jmp alltraps
8010610b:	e9 ae f7 ff ff       	jmp    801058be <alltraps>

80106110 <vector93>:
.globl vector93
vector93:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $93
80106112:	6a 5d                	push   $0x5d
  jmp alltraps
80106114:	e9 a5 f7 ff ff       	jmp    801058be <alltraps>

80106119 <vector94>:
.globl vector94
vector94:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $94
8010611b:	6a 5e                	push   $0x5e
  jmp alltraps
8010611d:	e9 9c f7 ff ff       	jmp    801058be <alltraps>

80106122 <vector95>:
.globl vector95
vector95:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $95
80106124:	6a 5f                	push   $0x5f
  jmp alltraps
80106126:	e9 93 f7 ff ff       	jmp    801058be <alltraps>

8010612b <vector96>:
.globl vector96
vector96:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $96
8010612d:	6a 60                	push   $0x60
  jmp alltraps
8010612f:	e9 8a f7 ff ff       	jmp    801058be <alltraps>

80106134 <vector97>:
.globl vector97
vector97:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $97
80106136:	6a 61                	push   $0x61
  jmp alltraps
80106138:	e9 81 f7 ff ff       	jmp    801058be <alltraps>

8010613d <vector98>:
.globl vector98
vector98:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $98
8010613f:	6a 62                	push   $0x62
  jmp alltraps
80106141:	e9 78 f7 ff ff       	jmp    801058be <alltraps>

80106146 <vector99>:
.globl vector99
vector99:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $99
80106148:	6a 63                	push   $0x63
  jmp alltraps
8010614a:	e9 6f f7 ff ff       	jmp    801058be <alltraps>

8010614f <vector100>:
.globl vector100
vector100:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $100
80106151:	6a 64                	push   $0x64
  jmp alltraps
80106153:	e9 66 f7 ff ff       	jmp    801058be <alltraps>

80106158 <vector101>:
.globl vector101
vector101:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $101
8010615a:	6a 65                	push   $0x65
  jmp alltraps
8010615c:	e9 5d f7 ff ff       	jmp    801058be <alltraps>

80106161 <vector102>:
.globl vector102
vector102:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $102
80106163:	6a 66                	push   $0x66
  jmp alltraps
80106165:	e9 54 f7 ff ff       	jmp    801058be <alltraps>

8010616a <vector103>:
.globl vector103
vector103:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $103
8010616c:	6a 67                	push   $0x67
  jmp alltraps
8010616e:	e9 4b f7 ff ff       	jmp    801058be <alltraps>

80106173 <vector104>:
.globl vector104
vector104:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $104
80106175:	6a 68                	push   $0x68
  jmp alltraps
80106177:	e9 42 f7 ff ff       	jmp    801058be <alltraps>

8010617c <vector105>:
.globl vector105
vector105:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $105
8010617e:	6a 69                	push   $0x69
  jmp alltraps
80106180:	e9 39 f7 ff ff       	jmp    801058be <alltraps>

80106185 <vector106>:
.globl vector106
vector106:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $106
80106187:	6a 6a                	push   $0x6a
  jmp alltraps
80106189:	e9 30 f7 ff ff       	jmp    801058be <alltraps>

8010618e <vector107>:
.globl vector107
vector107:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $107
80106190:	6a 6b                	push   $0x6b
  jmp alltraps
80106192:	e9 27 f7 ff ff       	jmp    801058be <alltraps>

80106197 <vector108>:
.globl vector108
vector108:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $108
80106199:	6a 6c                	push   $0x6c
  jmp alltraps
8010619b:	e9 1e f7 ff ff       	jmp    801058be <alltraps>

801061a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $109
801061a2:	6a 6d                	push   $0x6d
  jmp alltraps
801061a4:	e9 15 f7 ff ff       	jmp    801058be <alltraps>

801061a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $110
801061ab:	6a 6e                	push   $0x6e
  jmp alltraps
801061ad:	e9 0c f7 ff ff       	jmp    801058be <alltraps>

801061b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $111
801061b4:	6a 6f                	push   $0x6f
  jmp alltraps
801061b6:	e9 03 f7 ff ff       	jmp    801058be <alltraps>

801061bb <vector112>:
.globl vector112
vector112:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $112
801061bd:	6a 70                	push   $0x70
  jmp alltraps
801061bf:	e9 fa f6 ff ff       	jmp    801058be <alltraps>

801061c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $113
801061c6:	6a 71                	push   $0x71
  jmp alltraps
801061c8:	e9 f1 f6 ff ff       	jmp    801058be <alltraps>

801061cd <vector114>:
.globl vector114
vector114:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $114
801061cf:	6a 72                	push   $0x72
  jmp alltraps
801061d1:	e9 e8 f6 ff ff       	jmp    801058be <alltraps>

801061d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $115
801061d8:	6a 73                	push   $0x73
  jmp alltraps
801061da:	e9 df f6 ff ff       	jmp    801058be <alltraps>

801061df <vector116>:
.globl vector116
vector116:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $116
801061e1:	6a 74                	push   $0x74
  jmp alltraps
801061e3:	e9 d6 f6 ff ff       	jmp    801058be <alltraps>

801061e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $117
801061ea:	6a 75                	push   $0x75
  jmp alltraps
801061ec:	e9 cd f6 ff ff       	jmp    801058be <alltraps>

801061f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $118
801061f3:	6a 76                	push   $0x76
  jmp alltraps
801061f5:	e9 c4 f6 ff ff       	jmp    801058be <alltraps>

801061fa <vector119>:
.globl vector119
vector119:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $119
801061fc:	6a 77                	push   $0x77
  jmp alltraps
801061fe:	e9 bb f6 ff ff       	jmp    801058be <alltraps>

80106203 <vector120>:
.globl vector120
vector120:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $120
80106205:	6a 78                	push   $0x78
  jmp alltraps
80106207:	e9 b2 f6 ff ff       	jmp    801058be <alltraps>

8010620c <vector121>:
.globl vector121
vector121:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $121
8010620e:	6a 79                	push   $0x79
  jmp alltraps
80106210:	e9 a9 f6 ff ff       	jmp    801058be <alltraps>

80106215 <vector122>:
.globl vector122
vector122:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $122
80106217:	6a 7a                	push   $0x7a
  jmp alltraps
80106219:	e9 a0 f6 ff ff       	jmp    801058be <alltraps>

8010621e <vector123>:
.globl vector123
vector123:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $123
80106220:	6a 7b                	push   $0x7b
  jmp alltraps
80106222:	e9 97 f6 ff ff       	jmp    801058be <alltraps>

80106227 <vector124>:
.globl vector124
vector124:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $124
80106229:	6a 7c                	push   $0x7c
  jmp alltraps
8010622b:	e9 8e f6 ff ff       	jmp    801058be <alltraps>

80106230 <vector125>:
.globl vector125
vector125:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $125
80106232:	6a 7d                	push   $0x7d
  jmp alltraps
80106234:	e9 85 f6 ff ff       	jmp    801058be <alltraps>

80106239 <vector126>:
.globl vector126
vector126:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $126
8010623b:	6a 7e                	push   $0x7e
  jmp alltraps
8010623d:	e9 7c f6 ff ff       	jmp    801058be <alltraps>

80106242 <vector127>:
.globl vector127
vector127:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $127
80106244:	6a 7f                	push   $0x7f
  jmp alltraps
80106246:	e9 73 f6 ff ff       	jmp    801058be <alltraps>

8010624b <vector128>:
.globl vector128
vector128:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $128
8010624d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106252:	e9 67 f6 ff ff       	jmp    801058be <alltraps>

80106257 <vector129>:
.globl vector129
vector129:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $129
80106259:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010625e:	e9 5b f6 ff ff       	jmp    801058be <alltraps>

80106263 <vector130>:
.globl vector130
vector130:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $130
80106265:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010626a:	e9 4f f6 ff ff       	jmp    801058be <alltraps>

8010626f <vector131>:
.globl vector131
vector131:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $131
80106271:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106276:	e9 43 f6 ff ff       	jmp    801058be <alltraps>

8010627b <vector132>:
.globl vector132
vector132:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $132
8010627d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106282:	e9 37 f6 ff ff       	jmp    801058be <alltraps>

80106287 <vector133>:
.globl vector133
vector133:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $133
80106289:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010628e:	e9 2b f6 ff ff       	jmp    801058be <alltraps>

80106293 <vector134>:
.globl vector134
vector134:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $134
80106295:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010629a:	e9 1f f6 ff ff       	jmp    801058be <alltraps>

8010629f <vector135>:
.globl vector135
vector135:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $135
801062a1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062a6:	e9 13 f6 ff ff       	jmp    801058be <alltraps>

801062ab <vector136>:
.globl vector136
vector136:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $136
801062ad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062b2:	e9 07 f6 ff ff       	jmp    801058be <alltraps>

801062b7 <vector137>:
.globl vector137
vector137:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $137
801062b9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062be:	e9 fb f5 ff ff       	jmp    801058be <alltraps>

801062c3 <vector138>:
.globl vector138
vector138:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $138
801062c5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062ca:	e9 ef f5 ff ff       	jmp    801058be <alltraps>

801062cf <vector139>:
.globl vector139
vector139:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $139
801062d1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062d6:	e9 e3 f5 ff ff       	jmp    801058be <alltraps>

801062db <vector140>:
.globl vector140
vector140:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $140
801062dd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062e2:	e9 d7 f5 ff ff       	jmp    801058be <alltraps>

801062e7 <vector141>:
.globl vector141
vector141:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $141
801062e9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ee:	e9 cb f5 ff ff       	jmp    801058be <alltraps>

801062f3 <vector142>:
.globl vector142
vector142:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $142
801062f5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062fa:	e9 bf f5 ff ff       	jmp    801058be <alltraps>

801062ff <vector143>:
.globl vector143
vector143:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $143
80106301:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106306:	e9 b3 f5 ff ff       	jmp    801058be <alltraps>

8010630b <vector144>:
.globl vector144
vector144:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $144
8010630d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106312:	e9 a7 f5 ff ff       	jmp    801058be <alltraps>

80106317 <vector145>:
.globl vector145
vector145:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $145
80106319:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010631e:	e9 9b f5 ff ff       	jmp    801058be <alltraps>

80106323 <vector146>:
.globl vector146
vector146:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $146
80106325:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010632a:	e9 8f f5 ff ff       	jmp    801058be <alltraps>

8010632f <vector147>:
.globl vector147
vector147:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $147
80106331:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106336:	e9 83 f5 ff ff       	jmp    801058be <alltraps>

8010633b <vector148>:
.globl vector148
vector148:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $148
8010633d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106342:	e9 77 f5 ff ff       	jmp    801058be <alltraps>

80106347 <vector149>:
.globl vector149
vector149:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $149
80106349:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010634e:	e9 6b f5 ff ff       	jmp    801058be <alltraps>

80106353 <vector150>:
.globl vector150
vector150:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $150
80106355:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010635a:	e9 5f f5 ff ff       	jmp    801058be <alltraps>

8010635f <vector151>:
.globl vector151
vector151:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $151
80106361:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106366:	e9 53 f5 ff ff       	jmp    801058be <alltraps>

8010636b <vector152>:
.globl vector152
vector152:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $152
8010636d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106372:	e9 47 f5 ff ff       	jmp    801058be <alltraps>

80106377 <vector153>:
.globl vector153
vector153:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $153
80106379:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010637e:	e9 3b f5 ff ff       	jmp    801058be <alltraps>

80106383 <vector154>:
.globl vector154
vector154:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $154
80106385:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010638a:	e9 2f f5 ff ff       	jmp    801058be <alltraps>

8010638f <vector155>:
.globl vector155
vector155:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $155
80106391:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106396:	e9 23 f5 ff ff       	jmp    801058be <alltraps>

8010639b <vector156>:
.globl vector156
vector156:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $156
8010639d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063a2:	e9 17 f5 ff ff       	jmp    801058be <alltraps>

801063a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $157
801063a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ae:	e9 0b f5 ff ff       	jmp    801058be <alltraps>

801063b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $158
801063b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063ba:	e9 ff f4 ff ff       	jmp    801058be <alltraps>

801063bf <vector159>:
.globl vector159
vector159:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $159
801063c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063c6:	e9 f3 f4 ff ff       	jmp    801058be <alltraps>

801063cb <vector160>:
.globl vector160
vector160:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $160
801063cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063d2:	e9 e7 f4 ff ff       	jmp    801058be <alltraps>

801063d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $161
801063d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063de:	e9 db f4 ff ff       	jmp    801058be <alltraps>

801063e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $162
801063e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063ea:	e9 cf f4 ff ff       	jmp    801058be <alltraps>

801063ef <vector163>:
.globl vector163
vector163:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $163
801063f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063f6:	e9 c3 f4 ff ff       	jmp    801058be <alltraps>

801063fb <vector164>:
.globl vector164
vector164:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $164
801063fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106402:	e9 b7 f4 ff ff       	jmp    801058be <alltraps>

80106407 <vector165>:
.globl vector165
vector165:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $165
80106409:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010640e:	e9 ab f4 ff ff       	jmp    801058be <alltraps>

80106413 <vector166>:
.globl vector166
vector166:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $166
80106415:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010641a:	e9 9f f4 ff ff       	jmp    801058be <alltraps>

8010641f <vector167>:
.globl vector167
vector167:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $167
80106421:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106426:	e9 93 f4 ff ff       	jmp    801058be <alltraps>

8010642b <vector168>:
.globl vector168
vector168:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $168
8010642d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106432:	e9 87 f4 ff ff       	jmp    801058be <alltraps>

80106437 <vector169>:
.globl vector169
vector169:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $169
80106439:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010643e:	e9 7b f4 ff ff       	jmp    801058be <alltraps>

80106443 <vector170>:
.globl vector170
vector170:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $170
80106445:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010644a:	e9 6f f4 ff ff       	jmp    801058be <alltraps>

8010644f <vector171>:
.globl vector171
vector171:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $171
80106451:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106456:	e9 63 f4 ff ff       	jmp    801058be <alltraps>

8010645b <vector172>:
.globl vector172
vector172:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $172
8010645d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106462:	e9 57 f4 ff ff       	jmp    801058be <alltraps>

80106467 <vector173>:
.globl vector173
vector173:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $173
80106469:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010646e:	e9 4b f4 ff ff       	jmp    801058be <alltraps>

80106473 <vector174>:
.globl vector174
vector174:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $174
80106475:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010647a:	e9 3f f4 ff ff       	jmp    801058be <alltraps>

8010647f <vector175>:
.globl vector175
vector175:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $175
80106481:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106486:	e9 33 f4 ff ff       	jmp    801058be <alltraps>

8010648b <vector176>:
.globl vector176
vector176:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $176
8010648d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106492:	e9 27 f4 ff ff       	jmp    801058be <alltraps>

80106497 <vector177>:
.globl vector177
vector177:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $177
80106499:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010649e:	e9 1b f4 ff ff       	jmp    801058be <alltraps>

801064a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $178
801064a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064aa:	e9 0f f4 ff ff       	jmp    801058be <alltraps>

801064af <vector179>:
.globl vector179
vector179:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $179
801064b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064b6:	e9 03 f4 ff ff       	jmp    801058be <alltraps>

801064bb <vector180>:
.globl vector180
vector180:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $180
801064bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064c2:	e9 f7 f3 ff ff       	jmp    801058be <alltraps>

801064c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $181
801064c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064ce:	e9 eb f3 ff ff       	jmp    801058be <alltraps>

801064d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $182
801064d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064da:	e9 df f3 ff ff       	jmp    801058be <alltraps>

801064df <vector183>:
.globl vector183
vector183:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $183
801064e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064e6:	e9 d3 f3 ff ff       	jmp    801058be <alltraps>

801064eb <vector184>:
.globl vector184
vector184:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $184
801064ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064f2:	e9 c7 f3 ff ff       	jmp    801058be <alltraps>

801064f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $185
801064f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064fe:	e9 bb f3 ff ff       	jmp    801058be <alltraps>

80106503 <vector186>:
.globl vector186
vector186:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $186
80106505:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010650a:	e9 af f3 ff ff       	jmp    801058be <alltraps>

8010650f <vector187>:
.globl vector187
vector187:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $187
80106511:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106516:	e9 a3 f3 ff ff       	jmp    801058be <alltraps>

8010651b <vector188>:
.globl vector188
vector188:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $188
8010651d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106522:	e9 97 f3 ff ff       	jmp    801058be <alltraps>

80106527 <vector189>:
.globl vector189
vector189:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $189
80106529:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010652e:	e9 8b f3 ff ff       	jmp    801058be <alltraps>

80106533 <vector190>:
.globl vector190
vector190:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $190
80106535:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010653a:	e9 7f f3 ff ff       	jmp    801058be <alltraps>

8010653f <vector191>:
.globl vector191
vector191:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $191
80106541:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106546:	e9 73 f3 ff ff       	jmp    801058be <alltraps>

8010654b <vector192>:
.globl vector192
vector192:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $192
8010654d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106552:	e9 67 f3 ff ff       	jmp    801058be <alltraps>

80106557 <vector193>:
.globl vector193
vector193:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $193
80106559:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010655e:	e9 5b f3 ff ff       	jmp    801058be <alltraps>

80106563 <vector194>:
.globl vector194
vector194:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $194
80106565:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010656a:	e9 4f f3 ff ff       	jmp    801058be <alltraps>

8010656f <vector195>:
.globl vector195
vector195:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $195
80106571:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106576:	e9 43 f3 ff ff       	jmp    801058be <alltraps>

8010657b <vector196>:
.globl vector196
vector196:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $196
8010657d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106582:	e9 37 f3 ff ff       	jmp    801058be <alltraps>

80106587 <vector197>:
.globl vector197
vector197:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $197
80106589:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010658e:	e9 2b f3 ff ff       	jmp    801058be <alltraps>

80106593 <vector198>:
.globl vector198
vector198:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $198
80106595:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010659a:	e9 1f f3 ff ff       	jmp    801058be <alltraps>

8010659f <vector199>:
.globl vector199
vector199:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $199
801065a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065a6:	e9 13 f3 ff ff       	jmp    801058be <alltraps>

801065ab <vector200>:
.globl vector200
vector200:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $200
801065ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065b2:	e9 07 f3 ff ff       	jmp    801058be <alltraps>

801065b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $201
801065b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065be:	e9 fb f2 ff ff       	jmp    801058be <alltraps>

801065c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $202
801065c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065ca:	e9 ef f2 ff ff       	jmp    801058be <alltraps>

801065cf <vector203>:
.globl vector203
vector203:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $203
801065d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065d6:	e9 e3 f2 ff ff       	jmp    801058be <alltraps>

801065db <vector204>:
.globl vector204
vector204:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $204
801065dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065e2:	e9 d7 f2 ff ff       	jmp    801058be <alltraps>

801065e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $205
801065e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ee:	e9 cb f2 ff ff       	jmp    801058be <alltraps>

801065f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $206
801065f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065fa:	e9 bf f2 ff ff       	jmp    801058be <alltraps>

801065ff <vector207>:
.globl vector207
vector207:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $207
80106601:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106606:	e9 b3 f2 ff ff       	jmp    801058be <alltraps>

8010660b <vector208>:
.globl vector208
vector208:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $208
8010660d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106612:	e9 a7 f2 ff ff       	jmp    801058be <alltraps>

80106617 <vector209>:
.globl vector209
vector209:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $209
80106619:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010661e:	e9 9b f2 ff ff       	jmp    801058be <alltraps>

80106623 <vector210>:
.globl vector210
vector210:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $210
80106625:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010662a:	e9 8f f2 ff ff       	jmp    801058be <alltraps>

8010662f <vector211>:
.globl vector211
vector211:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $211
80106631:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106636:	e9 83 f2 ff ff       	jmp    801058be <alltraps>

8010663b <vector212>:
.globl vector212
vector212:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $212
8010663d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106642:	e9 77 f2 ff ff       	jmp    801058be <alltraps>

80106647 <vector213>:
.globl vector213
vector213:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $213
80106649:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010664e:	e9 6b f2 ff ff       	jmp    801058be <alltraps>

80106653 <vector214>:
.globl vector214
vector214:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $214
80106655:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010665a:	e9 5f f2 ff ff       	jmp    801058be <alltraps>

8010665f <vector215>:
.globl vector215
vector215:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $215
80106661:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106666:	e9 53 f2 ff ff       	jmp    801058be <alltraps>

8010666b <vector216>:
.globl vector216
vector216:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $216
8010666d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106672:	e9 47 f2 ff ff       	jmp    801058be <alltraps>

80106677 <vector217>:
.globl vector217
vector217:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $217
80106679:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010667e:	e9 3b f2 ff ff       	jmp    801058be <alltraps>

80106683 <vector218>:
.globl vector218
vector218:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $218
80106685:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010668a:	e9 2f f2 ff ff       	jmp    801058be <alltraps>

8010668f <vector219>:
.globl vector219
vector219:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $219
80106691:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106696:	e9 23 f2 ff ff       	jmp    801058be <alltraps>

8010669b <vector220>:
.globl vector220
vector220:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $220
8010669d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066a2:	e9 17 f2 ff ff       	jmp    801058be <alltraps>

801066a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $221
801066a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ae:	e9 0b f2 ff ff       	jmp    801058be <alltraps>

801066b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $222
801066b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066ba:	e9 ff f1 ff ff       	jmp    801058be <alltraps>

801066bf <vector223>:
.globl vector223
vector223:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $223
801066c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066c6:	e9 f3 f1 ff ff       	jmp    801058be <alltraps>

801066cb <vector224>:
.globl vector224
vector224:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $224
801066cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066d2:	e9 e7 f1 ff ff       	jmp    801058be <alltraps>

801066d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $225
801066d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066de:	e9 db f1 ff ff       	jmp    801058be <alltraps>

801066e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $226
801066e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066ea:	e9 cf f1 ff ff       	jmp    801058be <alltraps>

801066ef <vector227>:
.globl vector227
vector227:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $227
801066f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066f6:	e9 c3 f1 ff ff       	jmp    801058be <alltraps>

801066fb <vector228>:
.globl vector228
vector228:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $228
801066fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106702:	e9 b7 f1 ff ff       	jmp    801058be <alltraps>

80106707 <vector229>:
.globl vector229
vector229:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $229
80106709:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010670e:	e9 ab f1 ff ff       	jmp    801058be <alltraps>

80106713 <vector230>:
.globl vector230
vector230:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $230
80106715:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010671a:	e9 9f f1 ff ff       	jmp    801058be <alltraps>

8010671f <vector231>:
.globl vector231
vector231:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $231
80106721:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106726:	e9 93 f1 ff ff       	jmp    801058be <alltraps>

8010672b <vector232>:
.globl vector232
vector232:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $232
8010672d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106732:	e9 87 f1 ff ff       	jmp    801058be <alltraps>

80106737 <vector233>:
.globl vector233
vector233:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $233
80106739:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010673e:	e9 7b f1 ff ff       	jmp    801058be <alltraps>

80106743 <vector234>:
.globl vector234
vector234:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $234
80106745:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010674a:	e9 6f f1 ff ff       	jmp    801058be <alltraps>

8010674f <vector235>:
.globl vector235
vector235:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $235
80106751:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106756:	e9 63 f1 ff ff       	jmp    801058be <alltraps>

8010675b <vector236>:
.globl vector236
vector236:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $236
8010675d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106762:	e9 57 f1 ff ff       	jmp    801058be <alltraps>

80106767 <vector237>:
.globl vector237
vector237:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $237
80106769:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010676e:	e9 4b f1 ff ff       	jmp    801058be <alltraps>

80106773 <vector238>:
.globl vector238
vector238:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $238
80106775:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010677a:	e9 3f f1 ff ff       	jmp    801058be <alltraps>

8010677f <vector239>:
.globl vector239
vector239:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $239
80106781:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106786:	e9 33 f1 ff ff       	jmp    801058be <alltraps>

8010678b <vector240>:
.globl vector240
vector240:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $240
8010678d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106792:	e9 27 f1 ff ff       	jmp    801058be <alltraps>

80106797 <vector241>:
.globl vector241
vector241:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $241
80106799:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010679e:	e9 1b f1 ff ff       	jmp    801058be <alltraps>

801067a3 <vector242>:
.globl vector242
vector242:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $242
801067a5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067aa:	e9 0f f1 ff ff       	jmp    801058be <alltraps>

801067af <vector243>:
.globl vector243
vector243:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $243
801067b1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067b6:	e9 03 f1 ff ff       	jmp    801058be <alltraps>

801067bb <vector244>:
.globl vector244
vector244:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $244
801067bd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067c2:	e9 f7 f0 ff ff       	jmp    801058be <alltraps>

801067c7 <vector245>:
.globl vector245
vector245:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $245
801067c9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067ce:	e9 eb f0 ff ff       	jmp    801058be <alltraps>

801067d3 <vector246>:
.globl vector246
vector246:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $246
801067d5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067da:	e9 df f0 ff ff       	jmp    801058be <alltraps>

801067df <vector247>:
.globl vector247
vector247:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $247
801067e1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067e6:	e9 d3 f0 ff ff       	jmp    801058be <alltraps>

801067eb <vector248>:
.globl vector248
vector248:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $248
801067ed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067f2:	e9 c7 f0 ff ff       	jmp    801058be <alltraps>

801067f7 <vector249>:
.globl vector249
vector249:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $249
801067f9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067fe:	e9 bb f0 ff ff       	jmp    801058be <alltraps>

80106803 <vector250>:
.globl vector250
vector250:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $250
80106805:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010680a:	e9 af f0 ff ff       	jmp    801058be <alltraps>

8010680f <vector251>:
.globl vector251
vector251:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $251
80106811:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106816:	e9 a3 f0 ff ff       	jmp    801058be <alltraps>

8010681b <vector252>:
.globl vector252
vector252:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $252
8010681d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106822:	e9 97 f0 ff ff       	jmp    801058be <alltraps>

80106827 <vector253>:
.globl vector253
vector253:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $253
80106829:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010682e:	e9 8b f0 ff ff       	jmp    801058be <alltraps>

80106833 <vector254>:
.globl vector254
vector254:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $254
80106835:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010683a:	e9 7f f0 ff ff       	jmp    801058be <alltraps>

8010683f <vector255>:
.globl vector255
vector255:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $255
80106841:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106846:	e9 73 f0 ff ff       	jmp    801058be <alltraps>
8010684b:	66 90                	xchg   %ax,%ax
8010684d:	66 90                	xchg   %ax,%ax
8010684f:	90                   	nop

80106850 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	56                   	push   %esi
80106855:	89 d6                	mov    %edx,%esi

  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106857:	c1 ea 16             	shr    $0x16,%edx
{
8010685a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010685b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010685e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106861:	8b 1f                	mov    (%edi),%ebx
80106863:	f6 c3 01             	test   $0x1,%bl
80106866:	74 28                	je     80106890 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106868:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010686e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106874:	89 f0                	mov    %esi,%eax
}
80106876:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106879:	c1 e8 0a             	shr    $0xa,%eax
8010687c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106881:	01 d8                	add    %ebx,%eax
}
80106883:	5b                   	pop    %ebx
80106884:	5e                   	pop    %esi
80106885:	5f                   	pop    %edi
80106886:	5d                   	pop    %ebp
80106887:	c3                   	ret    
80106888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010688f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106890:	85 c9                	test   %ecx,%ecx
80106892:	74 2c                	je     801068c0 <walkpgdir+0x70>
80106894:	e8 d7 bd ff ff       	call   80102670 <kalloc>
80106899:	89 c3                	mov    %eax,%ebx
8010689b:	85 c0                	test   %eax,%eax
8010689d:	74 21                	je     801068c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010689f:	83 ec 04             	sub    $0x4,%esp
801068a2:	68 00 10 00 00       	push   $0x1000
801068a7:	6a 00                	push   $0x0
801068a9:	50                   	push   %eax
801068aa:	e8 e1 dd ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068b5:	83 c4 10             	add    $0x10,%esp
801068b8:	83 c8 07             	or     $0x7,%eax
801068bb:	89 07                	mov    %eax,(%edi)
801068bd:	eb b5                	jmp    80106874 <walkpgdir+0x24>
801068bf:	90                   	nop
}
801068c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801068c3:	31 c0                	xor    %eax,%eax
}
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret    
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	89 c6                	mov    %eax,%esi
801068d7:	53                   	push   %ebx
801068d8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068da:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801068e0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068e6:	83 ec 1c             	sub    $0x1c,%esp
801068e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068ec:	39 da                	cmp    %ebx,%edx
801068ee:	73 5b                	jae    8010694b <deallocuvm.part.0+0x7b>
801068f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801068f3:	89 d7                	mov    %edx,%edi
801068f5:	eb 14                	jmp    8010690b <deallocuvm.part.0+0x3b>
801068f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068fe:	66 90                	xchg   %ax,%ax
80106900:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106906:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106909:	76 40                	jbe    8010694b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010690b:	31 c9                	xor    %ecx,%ecx
8010690d:	89 fa                	mov    %edi,%edx
8010690f:	89 f0                	mov    %esi,%eax
80106911:	e8 3a ff ff ff       	call   80106850 <walkpgdir>
80106916:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106918:	85 c0                	test   %eax,%eax
8010691a:	74 44                	je     80106960 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010691c:	8b 00                	mov    (%eax),%eax
8010691e:	a8 01                	test   $0x1,%al
80106920:	74 de                	je     80106900 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106922:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106927:	74 47                	je     80106970 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106929:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010692c:	05 00 00 00 80       	add    $0x80000000,%eax
80106931:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106937:	50                   	push   %eax
80106938:	e8 73 bb ff ff       	call   801024b0 <kfree>
      *pte = 0;
8010693d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106943:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106946:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106949:	77 c0                	ja     8010690b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010694b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010694e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106951:	5b                   	pop    %ebx
80106952:	5e                   	pop    %esi
80106953:	5f                   	pop    %edi
80106954:	5d                   	pop    %ebp
80106955:	c3                   	ret    
80106956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010695d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106960:	89 fa                	mov    %edi,%edx
80106962:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106968:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010696e:	eb 96                	jmp    80106906 <deallocuvm.part.0+0x36>
        panic("kfree");
80106970:	83 ec 0c             	sub    $0xc,%esp
80106973:	68 86 75 10 80       	push   $0x80107586
80106978:	e8 13 9a ff ff       	call   80100390 <panic>
8010697d:	8d 76 00             	lea    0x0(%esi),%esi

80106980 <seginit>:
{
80106980:	f3 0f 1e fb          	endbr32 
80106984:	55                   	push   %ebp
80106985:	89 e5                	mov    %esp,%ebp
80106987:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010698a:	e8 01 d0 ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
8010698f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106994:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010699a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010699e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801069a5:	ff 00 00 
801069a8:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801069af:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069b2:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801069b9:	ff 00 00 
801069bc:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801069c3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069c6:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801069cd:	ff 00 00 
801069d0:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801069d7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069da:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801069e1:	ff 00 00 
801069e4:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801069eb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801069ee:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801069f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069f7:	c1 e8 10             	shr    $0x10,%eax
801069fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801069fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a01:	0f 01 10             	lgdtl  (%eax)
}
80106a04:	c9                   	leave  
80106a05:	c3                   	ret    
80106a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi

80106a10 <mappages>:
{
80106a10:	f3 0f 1e fb          	endbr32 
80106a14:	55                   	push   %ebp
80106a15:	89 e5                	mov    %esp,%ebp
80106a17:	57                   	push   %edi
80106a18:	56                   	push   %esi
80106a19:	53                   	push   %ebx
80106a1a:	83 ec 1c             	sub    $0x1c,%esp
80106a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
{
80106a23:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
80106a26:	89 c6                	mov    %eax,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a28:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
80106a2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a31:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a3a:	8b 45 14             	mov    0x14(%ebp),%eax
80106a3d:	29 f0                	sub    %esi,%eax
80106a3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a42:	eb 1c                	jmp    80106a60 <mappages+0x50>
80106a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*pte & PTE_P)
80106a48:	f6 00 01             	testb  $0x1,(%eax)
80106a4b:	75 45                	jne    80106a92 <mappages+0x82>
    *pte = pa | perm | PTE_P;
80106a4d:	0b 5d 18             	or     0x18(%ebp),%ebx
80106a50:	83 cb 01             	or     $0x1,%ebx
80106a53:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106a55:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106a58:	74 2e                	je     80106a88 <mappages+0x78>
    a += PGSIZE;
80106a5a:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a63:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a68:	89 f2                	mov    %esi,%edx
80106a6a:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106a6d:	89 f8                	mov    %edi,%eax
80106a6f:	e8 dc fd ff ff       	call   80106850 <walkpgdir>
80106a74:	85 c0                	test   %eax,%eax
80106a76:	75 d0                	jne    80106a48 <mappages+0x38>
}
80106a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a80:	5b                   	pop    %ebx
80106a81:	5e                   	pop    %esi
80106a82:	5f                   	pop    %edi
80106a83:	5d                   	pop    %ebp
80106a84:	c3                   	ret    
80106a85:	8d 76 00             	lea    0x0(%esi),%esi
80106a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a8b:	31 c0                	xor    %eax,%eax
}
80106a8d:	5b                   	pop    %ebx
80106a8e:	5e                   	pop    %esi
80106a8f:	5f                   	pop    %edi
80106a90:	5d                   	pop    %ebp
80106a91:	c3                   	ret    
      panic("remap");
80106a92:	83 ec 0c             	sub    $0xc,%esp
80106a95:	68 4c 7c 10 80       	push   $0x80107c4c
80106a9a:	e8 f1 98 ff ff       	call   80100390 <panic>
80106a9f:	90                   	nop

80106aa0 <switchkvm>:
{
80106aa0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106aa4:	a1 c8 55 11 80       	mov    0x801155c8,%eax
80106aa9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aae:	0f 22 d8             	mov    %eax,%cr3
}
80106ab1:	c3                   	ret    
80106ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <switchuvm>:
{
80106ac0:	f3 0f 1e fb          	endbr32 
80106ac4:	55                   	push   %ebp
80106ac5:	89 e5                	mov    %esp,%ebp
80106ac7:	57                   	push   %edi
80106ac8:	56                   	push   %esi
80106ac9:	53                   	push   %ebx
80106aca:	83 ec 1c             	sub    $0x1c,%esp
80106acd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ad0:	85 f6                	test   %esi,%esi
80106ad2:	0f 84 cb 00 00 00    	je     80106ba3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106ad8:	8b 46 08             	mov    0x8(%esi),%eax
80106adb:	85 c0                	test   %eax,%eax
80106add:	0f 84 da 00 00 00    	je     80106bbd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106ae3:	8b 46 04             	mov    0x4(%esi),%eax
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	0f 84 c2 00 00 00    	je     80106bb0 <switchuvm+0xf0>
  pushcli();
80106aee:	e8 cd d9 ff ff       	call   801044c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106af3:	e8 28 ce ff ff       	call   80103920 <mycpu>
80106af8:	89 c3                	mov    %eax,%ebx
80106afa:	e8 21 ce ff ff       	call   80103920 <mycpu>
80106aff:	89 c7                	mov    %eax,%edi
80106b01:	e8 1a ce ff ff       	call   80103920 <mycpu>
80106b06:	83 c7 08             	add    $0x8,%edi
80106b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b0c:	e8 0f ce ff ff       	call   80103920 <mycpu>
80106b11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b14:	ba 67 00 00 00       	mov    $0x67,%edx
80106b19:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b20:	83 c0 08             	add    $0x8,%eax
80106b23:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b2a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b2f:	83 c1 08             	add    $0x8,%ecx
80106b32:	c1 e8 18             	shr    $0x18,%eax
80106b35:	c1 e9 10             	shr    $0x10,%ecx
80106b38:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b3e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b44:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b49:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b50:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b55:	e8 c6 cd ff ff       	call   80103920 <mycpu>
80106b5a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b61:	e8 ba cd ff ff       	call   80103920 <mycpu>
80106b66:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b6a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b73:	e8 a8 cd ff ff       	call   80103920 <mycpu>
80106b78:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b7b:	e8 a0 cd ff ff       	call   80103920 <mycpu>
80106b80:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b84:	b8 28 00 00 00       	mov    $0x28,%eax
80106b89:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b8c:	8b 46 04             	mov    0x4(%esi),%eax
80106b8f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b94:	0f 22 d8             	mov    %eax,%cr3
}
80106b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b9a:	5b                   	pop    %ebx
80106b9b:	5e                   	pop    %esi
80106b9c:	5f                   	pop    %edi
80106b9d:	5d                   	pop    %ebp
  popcli();
80106b9e:	e9 3d da ff ff       	jmp    801045e0 <popcli>
    panic("switchuvm: no process");
80106ba3:	83 ec 0c             	sub    $0xc,%esp
80106ba6:	68 52 7c 10 80       	push   $0x80107c52
80106bab:	e8 e0 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106bb0:	83 ec 0c             	sub    $0xc,%esp
80106bb3:	68 7d 7c 10 80       	push   $0x80107c7d
80106bb8:	e8 d3 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106bbd:	83 ec 0c             	sub    $0xc,%esp
80106bc0:	68 68 7c 10 80       	push   $0x80107c68
80106bc5:	e8 c6 97 ff ff       	call   80100390 <panic>
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bd0 <inituvm>:
{
80106bd0:	f3 0f 1e fb          	endbr32 
80106bd4:	55                   	push   %ebp
80106bd5:	89 e5                	mov    %esp,%ebp
80106bd7:	57                   	push   %edi
80106bd8:	56                   	push   %esi
80106bd9:	53                   	push   %ebx
80106bda:	83 ec 1c             	sub    $0x1c,%esp
80106bdd:	8b 75 10             	mov    0x10(%ebp),%esi
80106be0:	8b 55 08             	mov    0x8(%ebp),%edx
80106be3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106be6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bec:	77 50                	ja     80106c3e <inituvm+0x6e>
80106bee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106bf1:	e8 7a ba ff ff       	call   80102670 <kalloc>
  memset(mem, 0, PGSIZE);
80106bf6:	83 ec 04             	sub    $0x4,%esp
80106bf9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bfe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c00:	6a 00                	push   $0x0
80106c02:	50                   	push   %eax
80106c03:	e8 88 da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c0b:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c11:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106c18:	50                   	push   %eax
80106c19:	68 00 10 00 00       	push   $0x1000
80106c1e:	6a 00                	push   $0x0
80106c20:	52                   	push   %edx
80106c21:	e8 ea fd ff ff       	call   80106a10 <mappages>
  memmove(mem, init, sz);
80106c26:	89 75 10             	mov    %esi,0x10(%ebp)
80106c29:	83 c4 20             	add    $0x20,%esp
80106c2c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5f                   	pop    %edi
80106c38:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c39:	e9 f2 da ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80106c3e:	83 ec 0c             	sub    $0xc,%esp
80106c41:	68 91 7c 10 80       	push   $0x80107c91
80106c46:	e8 45 97 ff ff       	call   80100390 <panic>
80106c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c4f:	90                   	nop

80106c50 <loaduvm>:
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	57                   	push   %edi
80106c58:	56                   	push   %esi
80106c59:	53                   	push   %ebx
80106c5a:	83 ec 1c             	sub    $0x1c,%esp
80106c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c60:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c68:	0f 85 99 00 00 00    	jne    80106d07 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106c6e:	01 f0                	add    %esi,%eax
80106c70:	89 f3                	mov    %esi,%ebx
80106c72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c75:	8b 45 14             	mov    0x14(%ebp),%eax
80106c78:	01 f0                	add    %esi,%eax
80106c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c7d:	85 f6                	test   %esi,%esi
80106c7f:	75 15                	jne    80106c96 <loaduvm+0x46>
80106c81:	eb 6d                	jmp    80106cf0 <loaduvm+0xa0>
80106c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c87:	90                   	nop
80106c88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106c8e:	89 f0                	mov    %esi,%eax
80106c90:	29 d8                	sub    %ebx,%eax
80106c92:	39 c6                	cmp    %eax,%esi
80106c94:	76 5a                	jbe    80106cf0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9c:	31 c9                	xor    %ecx,%ecx
80106c9e:	29 da                	sub    %ebx,%edx
80106ca0:	e8 ab fb ff ff       	call   80106850 <walkpgdir>
80106ca5:	85 c0                	test   %eax,%eax
80106ca7:	74 51                	je     80106cfa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ca9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cb8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106cbe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cc1:	29 d9                	sub    %ebx,%ecx
80106cc3:	05 00 00 00 80       	add    $0x80000000,%eax
80106cc8:	57                   	push   %edi
80106cc9:	51                   	push   %ecx
80106cca:	50                   	push   %eax
80106ccb:	ff 75 10             	pushl  0x10(%ebp)
80106cce:	e8 cd ad ff ff       	call   80101aa0 <readi>
80106cd3:	83 c4 10             	add    $0x10,%esp
80106cd6:	39 f8                	cmp    %edi,%eax
80106cd8:	74 ae                	je     80106c88 <loaduvm+0x38>
}
80106cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ce2:	5b                   	pop    %ebx
80106ce3:	5e                   	pop    %esi
80106ce4:	5f                   	pop    %edi
80106ce5:	5d                   	pop    %ebp
80106ce6:	c3                   	ret    
80106ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cee:	66 90                	xchg   %ax,%ax
80106cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cf3:	31 c0                	xor    %eax,%eax
}
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106cfa:	83 ec 0c             	sub    $0xc,%esp
80106cfd:	68 ab 7c 10 80       	push   $0x80107cab
80106d02:	e8 89 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106d07:	83 ec 0c             	sub    $0xc,%esp
80106d0a:	68 b8 7d 10 80       	push   $0x80107db8
80106d0f:	e8 7c 96 ff ff       	call   80100390 <panic>
80106d14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d1f:	90                   	nop

80106d20 <allocuvm>:
{
80106d20:	f3 0f 1e fb          	endbr32 
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	57                   	push   %edi
80106d28:	56                   	push   %esi
80106d29:	53                   	push   %ebx
80106d2a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d2d:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d30:	85 ff                	test   %edi,%edi
80106d32:	0f 88 08 01 00 00    	js     80106e40 <allocuvm+0x120>
  if(newsz < oldsz)
80106d38:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d3b:	0f 82 ef 00 00 00    	jb     80106e30 <allocuvm+0x110>
  a = PGROUNDUP(oldsz);
80106d41:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d44:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d4a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d50:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d53:	0f 86 da 00 00 00    	jbe    80106e33 <allocuvm+0x113>
80106d59:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d5c:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d5f:	eb 4b                	jmp    80106dac <allocuvm+0x8c>
80106d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106d68:	83 ec 04             	sub    $0x4,%esp
80106d6b:	68 00 10 00 00       	push   $0x1000
80106d70:	6a 00                	push   $0x0
80106d72:	50                   	push   %eax
80106d73:	e8 18 d9 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d78:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d7e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106d85:	50                   	push   %eax
80106d86:	68 00 10 00 00       	push   $0x1000
80106d8b:	56                   	push   %esi
80106d8c:	57                   	push   %edi
80106d8d:	e8 7e fc ff ff       	call   80106a10 <mappages>
80106d92:	83 c4 20             	add    $0x20,%esp
80106d95:	85 c0                	test   %eax,%eax
80106d97:	0f 88 b3 00 00 00    	js     80106e50 <allocuvm+0x130>
  for(; a < newsz; a += PGSIZE){
80106d9d:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106da3:	39 75 10             	cmp    %esi,0x10(%ebp)
80106da6:	0f 86 e4 00 00 00    	jbe    80106e90 <allocuvm+0x170>
    mem = kalloc();
80106dac:	e8 bf b8 ff ff       	call   80102670 <kalloc>
80106db1:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106db3:	85 c0                	test   %eax,%eax
80106db5:	75 b1                	jne    80106d68 <allocuvm+0x48>
      cprintf("\nallocuvm out of memory\n");
80106db7:	83 ec 0c             	sub    $0xc,%esp
80106dba:	68 c9 7c 10 80       	push   $0x80107cc9
80106dbf:	e8 ec 98 ff ff       	call   801006b0 <cprintf>
      cprintf("\n\nAddress of Stack: %x\n", myproc()->tf->esp);
80106dc4:	e8 e7 cb ff ff       	call   801039b0 <myproc>
80106dc9:	5a                   	pop    %edx
80106dca:	59                   	pop    %ecx
80106dcb:	8b 40 18             	mov    0x18(%eax),%eax
80106dce:	ff 70 44             	pushl  0x44(%eax)
80106dd1:	68 e2 7c 10 80       	push   $0x80107ce2
80106dd6:	e8 d5 98 ff ff       	call   801006b0 <cprintf>
      cprintf("Address of user space: %x\n", myproc()->sz);
80106ddb:	e8 d0 cb ff ff       	call   801039b0 <myproc>
80106de0:	5b                   	pop    %ebx
80106de1:	5e                   	pop    %esi
80106de2:	ff 30                	pushl  (%eax)
80106de4:	68 fa 7c 10 80       	push   $0x80107cfa
80106de9:	e8 c2 98 ff ff       	call   801006b0 <cprintf>
      cprintf("Address of user space (plus guard): %x\n\n", myproc()->sz+PGSIZE);
80106dee:	e8 bd cb ff ff       	call   801039b0 <myproc>
80106df3:	5f                   	pop    %edi
80106df4:	5a                   	pop    %edx
80106df5:	8b 00                	mov    (%eax),%eax
80106df7:	05 00 10 00 00       	add    $0x1000,%eax
80106dfc:	50                   	push   %eax
80106dfd:	68 dc 7d 10 80       	push   $0x80107ddc
80106e02:	e8 a9 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e07:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e0a:	83 c4 10             	add    $0x10,%esp
80106e0d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e10:	74 2e                	je     80106e40 <allocuvm+0x120>
80106e12:	8b 55 10             	mov    0x10(%ebp),%edx
80106e15:	89 c1                	mov    %eax,%ecx
80106e17:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106e1a:	31 ff                	xor    %edi,%edi
80106e1c:	e8 af fa ff ff       	call   801068d0 <deallocuvm.part.0>
}
80106e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e24:	89 f8                	mov    %edi,%eax
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
80106e2a:	c3                   	ret    
80106e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop
    return oldsz;
80106e30:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	89 f8                	mov    %edi,%eax
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret    
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106e43:	31 ff                	xor    %edi,%edi
}
80106e45:	5b                   	pop    %ebx
80106e46:	89 f8                	mov    %edi,%eax
80106e48:	5e                   	pop    %esi
80106e49:	5f                   	pop    %edi
80106e4a:	5d                   	pop    %ebp
80106e4b:	c3                   	ret    
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("\nallocuvm out of memory (2)\n");
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	68 15 7d 10 80       	push   $0x80107d15
80106e58:	e8 53 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e66:	74 0d                	je     80106e75 <allocuvm+0x155>
80106e68:	89 c1                	mov    %eax,%ecx
80106e6a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e70:	e8 5b fa ff ff       	call   801068d0 <deallocuvm.part.0>
      kfree(mem);
80106e75:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106e78:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106e7a:	53                   	push   %ebx
80106e7b:	e8 30 b6 ff ff       	call   801024b0 <kfree>
      return 0;
80106e80:	83 c4 10             	add    $0x10,%esp
}
80106e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e86:	89 f8                	mov    %edi,%eax
80106e88:	5b                   	pop    %ebx
80106e89:	5e                   	pop    %esi
80106e8a:	5f                   	pop    %edi
80106e8b:	5d                   	pop    %ebp
80106e8c:	c3                   	ret    
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi
80106e90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	89 f8                	mov    %edi,%eax
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret    
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ea0 <deallocuvm>:
{
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
80106ea5:	89 e5                	mov    %esp,%ebp
80106ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ead:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106eb0:	39 d1                	cmp    %edx,%ecx
80106eb2:	73 0c                	jae    80106ec0 <deallocuvm+0x20>
}
80106eb4:	5d                   	pop    %ebp
80106eb5:	e9 16 fa ff ff       	jmp    801068d0 <deallocuvm.part.0>
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ec0:	89 d0                	mov    %edx,%eax
80106ec2:	5d                   	pop    %ebp
80106ec3:	c3                   	ret    
80106ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ecf:	90                   	nop

80106ed0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ed0:	f3 0f 1e fb          	endbr32 
80106ed4:	55                   	push   %ebp
80106ed5:	89 e5                	mov    %esp,%ebp
80106ed7:	57                   	push   %edi
80106ed8:	56                   	push   %esi
80106ed9:	53                   	push   %ebx
80106eda:	83 ec 0c             	sub    $0xc,%esp
80106edd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ee0:	85 f6                	test   %esi,%esi
80106ee2:	74 55                	je     80106f39 <freevm+0x69>
  if(newsz >= oldsz)
80106ee4:	31 c9                	xor    %ecx,%ecx
80106ee6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eeb:	89 f0                	mov    %esi,%eax
80106eed:	89 f3                	mov    %esi,%ebx
80106eef:	e8 dc f9 ff ff       	call   801068d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ef4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106efa:	eb 0b                	jmp    80106f07 <freevm+0x37>
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f00:	83 c3 04             	add    $0x4,%ebx
80106f03:	39 df                	cmp    %ebx,%edi
80106f05:	74 23                	je     80106f2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f07:	8b 03                	mov    (%ebx),%eax
80106f09:	a8 01                	test   $0x1,%al
80106f0b:	74 f3                	je     80106f00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f12:	83 ec 0c             	sub    $0xc,%esp
80106f15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f1d:	50                   	push   %eax
80106f1e:	e8 8d b5 ff ff       	call   801024b0 <kfree>
80106f23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f26:	39 df                	cmp    %ebx,%edi
80106f28:	75 dd                	jne    80106f07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f30:	5b                   	pop    %ebx
80106f31:	5e                   	pop    %esi
80106f32:	5f                   	pop    %edi
80106f33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f34:	e9 77 b5 ff ff       	jmp    801024b0 <kfree>
    panic("freevm: no pgdir");
80106f39:	83 ec 0c             	sub    $0xc,%esp
80106f3c:	68 32 7d 10 80       	push   $0x80107d32
80106f41:	e8 4a 94 ff ff       	call   80100390 <panic>
80106f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi

80106f50 <setupkvm>:
{
80106f50:	f3 0f 1e fb          	endbr32 
80106f54:	55                   	push   %ebp
80106f55:	89 e5                	mov    %esp,%ebp
80106f57:	56                   	push   %esi
80106f58:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f59:	e8 12 b7 ff ff       	call   80102670 <kalloc>
80106f5e:	89 c6                	mov    %eax,%esi
80106f60:	85 c0                	test   %eax,%eax
80106f62:	74 42                	je     80106fa6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106f64:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f67:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f6c:	68 00 10 00 00       	push   $0x1000
80106f71:	6a 00                	push   $0x0
80106f73:	50                   	push   %eax
80106f74:	e8 17 d7 ff ff       	call   80104690 <memset>
80106f79:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f7c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f7f:	8b 53 08             	mov    0x8(%ebx),%edx
80106f82:	83 ec 0c             	sub    $0xc,%esp
80106f85:	ff 73 0c             	pushl  0xc(%ebx)
80106f88:	29 c2                	sub    %eax,%edx
80106f8a:	50                   	push   %eax
80106f8b:	52                   	push   %edx
80106f8c:	ff 33                	pushl  (%ebx)
80106f8e:	56                   	push   %esi
80106f8f:	e8 7c fa ff ff       	call   80106a10 <mappages>
80106f94:	83 c4 20             	add    $0x20,%esp
80106f97:	85 c0                	test   %eax,%eax
80106f99:	78 15                	js     80106fb0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f9b:	83 c3 10             	add    $0x10,%ebx
80106f9e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fa4:	75 d6                	jne    80106f7c <setupkvm+0x2c>
}
80106fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fa9:	89 f0                	mov    %esi,%eax
80106fab:	5b                   	pop    %ebx
80106fac:	5e                   	pop    %esi
80106fad:	5d                   	pop    %ebp
80106fae:	c3                   	ret    
80106faf:	90                   	nop
      freevm(pgdir);
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	56                   	push   %esi
      return 0;
80106fb4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fb6:	e8 15 ff ff ff       	call   80106ed0 <freevm>
      return 0;
80106fbb:	83 c4 10             	add    $0x10,%esp
}
80106fbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fc1:	89 f0                	mov    %esi,%eax
80106fc3:	5b                   	pop    %ebx
80106fc4:	5e                   	pop    %esi
80106fc5:	5d                   	pop    %ebp
80106fc6:	c3                   	ret    
80106fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fce:	66 90                	xchg   %ax,%ax

80106fd0 <kvmalloc>:
{
80106fd0:	f3 0f 1e fb          	endbr32 
80106fd4:	55                   	push   %ebp
80106fd5:	89 e5                	mov    %esp,%ebp
80106fd7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fda:	e8 71 ff ff ff       	call   80106f50 <setupkvm>
80106fdf:	a3 c8 55 11 80       	mov    %eax,0x801155c8
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fe4:	05 00 00 00 80       	add    $0x80000000,%eax
80106fe9:	0f 22 d8             	mov    %eax,%cr3
}
80106fec:	c9                   	leave  
80106fed:	c3                   	ret    
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ff0:	f3 0f 1e fb          	endbr32 
80106ff4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ff5:	31 c9                	xor    %ecx,%ecx
{
80106ff7:	89 e5                	mov    %esp,%ebp
80106ff9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fff:	8b 45 08             	mov    0x8(%ebp),%eax
80107002:	e8 49 f8 ff ff       	call   80106850 <walkpgdir>
  if(pte == 0)
80107007:	85 c0                	test   %eax,%eax
80107009:	74 05                	je     80107010 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010700b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010700e:	c9                   	leave  
8010700f:	c3                   	ret    
    panic("clearpteu");
80107010:	83 ec 0c             	sub    $0xc,%esp
80107013:	68 43 7d 10 80       	push   $0x80107d43
80107018:	e8 73 93 ff ff       	call   80100390 <panic>
8010701d:	8d 76 00             	lea    0x0(%esi),%esi

80107020 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107020:	f3 0f 1e fb          	endbr32 
80107024:	55                   	push   %ebp
80107025:	89 e5                	mov    %esp,%ebp
80107027:	57                   	push   %edi
80107028:	56                   	push   %esi
80107029:	53                   	push   %ebx
8010702a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010702d:	e8 1e ff ff ff       	call   80106f50 <setupkvm>
80107032:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107035:	85 c0                	test   %eax,%eax
80107037:	0f 84 a3 00 00 00    	je     801070e0 <copyuvm+0xc0>
  //cprintf("\n\nAbove original copy for loop for 0 to sz in VA...\n\n");

  
  // copies user text and data (code) from the lower user space
  // (i.e., global/static variables) up to sz
  for(i = 0; i < sz; i += PGSIZE){
8010703d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107040:	85 c0                	test   %eax,%eax
80107042:	0f 84 a8 00 00 00    	je     801070f0 <copyuvm+0xd0>
80107048:	31 f6                	xor    %esi,%esi
8010704a:	eb 49                	jmp    80107095 <copyuvm+0x75>
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0) {
      //cprintf("about to 'goto bad', original copy loop\n");
      goto bad;
    }
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107050:	83 ec 04             	sub    $0x4,%esp
80107053:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010705c:	68 00 10 00 00       	push   $0x1000
80107061:	57                   	push   %edi
80107062:	50                   	push   %eax
80107063:	e8 c8 d6 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107068:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010706b:	89 1c 24             	mov    %ebx,(%esp)
8010706e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107074:	52                   	push   %edx
80107075:	68 00 10 00 00       	push   $0x1000
8010707a:	56                   	push   %esi
8010707b:	ff 75 e0             	pushl  -0x20(%ebp)
8010707e:	e8 8d f9 ff ff       	call   80106a10 <mappages>
80107083:	83 c4 20             	add    $0x20,%esp
80107086:	85 c0                	test   %eax,%eax
80107088:	78 41                	js     801070cb <copyuvm+0xab>
  for(i = 0; i < sz; i += PGSIZE){
8010708a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107090:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107093:	76 5b                	jbe    801070f0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107095:	8b 45 08             	mov    0x8(%ebp),%eax
80107098:	31 c9                	xor    %ecx,%ecx
8010709a:	89 f2                	mov    %esi,%edx
8010709c:	e8 af f7 ff ff       	call   80106850 <walkpgdir>
801070a1:	85 c0                	test   %eax,%eax
801070a3:	0f 84 ef 00 00 00    	je     80107198 <copyuvm+0x178>
    if(!(*pte & PTE_P))
801070a9:	8b 18                	mov    (%eax),%ebx
801070ab:	f6 c3 01             	test   $0x1,%bl
801070ae:	0f 84 d7 00 00 00    	je     8010718b <copyuvm+0x16b>
    pa = PTE_ADDR(*pte);
801070b4:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801070b6:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801070bc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0) {
801070c2:	e8 a9 b5 ff ff       	call   80102670 <kalloc>
801070c7:	85 c0                	test   %eax,%eax
801070c9:	75 85                	jne    80107050 <copyuvm+0x30>
  //cprintf("about to leave copyuvm...\n\n");

  return d;

bad:
  freevm(d);
801070cb:	83 ec 0c             	sub    $0xc,%esp
801070ce:	ff 75 e0             	pushl  -0x20(%ebp)
801070d1:	e8 fa fd ff ff       	call   80106ed0 <freevm>
  return 0;
801070d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070dd:	83 c4 10             	add    $0x10,%esp
}
801070e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e6:	5b                   	pop    %ebx
801070e7:	5e                   	pop    %esi
801070e8:	5f                   	pop    %edi
801070e9:	5d                   	pop    %ebp
801070ea:	c3                   	ret    
801070eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop
  for(i = (STACKBASE - myproc()->numStackPages*PGSIZE + 4); i < STACKBASE; i += PGSIZE){
801070f0:	e8 bb c8 ff ff       	call   801039b0 <myproc>
801070f5:	be 00 00 08 00       	mov    $0x80000,%esi
801070fa:	2b 70 7c             	sub    0x7c(%eax),%esi
801070fd:	c1 e6 0c             	shl    $0xc,%esi
80107100:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80107106:	76 50                	jbe    80107158 <copyuvm+0x138>
80107108:	eb d6                	jmp    801070e0 <copyuvm+0xc0>
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107110:	83 ec 04             	sub    $0x4,%esp
80107113:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010711c:	68 00 10 00 00       	push   $0x1000
80107121:	57                   	push   %edi
80107122:	50                   	push   %eax
80107123:	e8 08 d6 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107128:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010712b:	89 1c 24             	mov    %ebx,(%esp)
8010712e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107134:	52                   	push   %edx
80107135:	68 00 10 00 00       	push   $0x1000
8010713a:	56                   	push   %esi
8010713b:	ff 75 e0             	pushl  -0x20(%ebp)
8010713e:	e8 cd f8 ff ff       	call   80106a10 <mappages>
80107143:	83 c4 20             	add    $0x20,%esp
80107146:	85 c0                	test   %eax,%eax
80107148:	78 81                	js     801070cb <copyuvm+0xab>
  for(i = (STACKBASE - myproc()->numStackPages*PGSIZE + 4); i < STACKBASE; i += PGSIZE){
8010714a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107150:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80107156:	77 88                	ja     801070e0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107158:	8b 45 08             	mov    0x8(%ebp),%eax
8010715b:	31 c9                	xor    %ecx,%ecx
8010715d:	89 f2                	mov    %esi,%edx
8010715f:	e8 ec f6 ff ff       	call   80106850 <walkpgdir>
80107164:	85 c0                	test   %eax,%eax
80107166:	74 3d                	je     801071a5 <copyuvm+0x185>
    if(!(*pte & PTE_P))
80107168:	8b 18                	mov    (%eax),%ebx
8010716a:	f6 c3 01             	test   $0x1,%bl
8010716d:	74 43                	je     801071b2 <copyuvm+0x192>
    pa = PTE_ADDR(*pte);
8010716f:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107171:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107177:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0) {
8010717d:	e8 ee b4 ff ff       	call   80102670 <kalloc>
80107182:	85 c0                	test   %eax,%eax
80107184:	75 8a                	jne    80107110 <copyuvm+0xf0>
80107186:	e9 40 ff ff ff       	jmp    801070cb <copyuvm+0xab>
      panic("copyuvm: page not present");
8010718b:	83 ec 0c             	sub    $0xc,%esp
8010718e:	68 67 7d 10 80       	push   $0x80107d67
80107193:	e8 f8 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107198:	83 ec 0c             	sub    $0xc,%esp
8010719b:	68 4d 7d 10 80       	push   $0x80107d4d
801071a0:	e8 eb 91 ff ff       	call   80100390 <panic>
      panic("copyuvm2: pte should exist");
801071a5:	83 ec 0c             	sub    $0xc,%esp
801071a8:	68 81 7d 10 80       	push   $0x80107d81
801071ad:	e8 de 91 ff ff       	call   80100390 <panic>
      panic("copyuvm2: page not present");
801071b2:	83 ec 0c             	sub    $0xc,%esp
801071b5:	68 9c 7d 10 80       	push   $0x80107d9c
801071ba:	e8 d1 91 ff ff       	call   80100390 <panic>
801071bf:	90                   	nop

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c5:	31 c9                	xor    %ecx,%ecx
{
801071c7:	89 e5                	mov    %esp,%ebp
801071c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cf:	8b 45 08             	mov    0x8(%ebp),%eax
801071d2:	e8 79 f6 ff ff       	call   80106850 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071d7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071d9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801071da:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801071e1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071e4:	05 00 00 00 80       	add    $0x80000000,%eax
801071e9:	83 fa 05             	cmp    $0x5,%edx
801071ec:	ba 00 00 00 00       	mov    $0x0,%edx
801071f1:	0f 45 c2             	cmovne %edx,%eax
}
801071f4:	c3                   	ret    
801071f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107200 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107200:	f3 0f 1e fb          	endbr32 
80107204:	55                   	push   %ebp
80107205:	89 e5                	mov    %esp,%ebp
80107207:	57                   	push   %edi
80107208:	56                   	push   %esi
80107209:	53                   	push   %ebx
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	8b 75 14             	mov    0x14(%ebp),%esi
80107210:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107213:	85 f6                	test   %esi,%esi
80107215:	75 3c                	jne    80107253 <copyout+0x53>
80107217:	eb 67                	jmp    80107280 <copyout+0x80>
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107220:	8b 55 0c             	mov    0xc(%ebp),%edx
80107223:	89 fb                	mov    %edi,%ebx
80107225:	29 d3                	sub    %edx,%ebx
80107227:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010722d:	39 f3                	cmp    %esi,%ebx
8010722f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107232:	29 fa                	sub    %edi,%edx
80107234:	83 ec 04             	sub    $0x4,%esp
80107237:	01 c2                	add    %eax,%edx
80107239:	53                   	push   %ebx
8010723a:	ff 75 10             	pushl  0x10(%ebp)
8010723d:	52                   	push   %edx
8010723e:	e8 ed d4 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
80107243:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107246:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010724c:	83 c4 10             	add    $0x10,%esp
8010724f:	29 de                	sub    %ebx,%esi
80107251:	74 2d                	je     80107280 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107253:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107255:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107258:	89 55 0c             	mov    %edx,0xc(%ebp)
8010725b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107261:	57                   	push   %edi
80107262:	ff 75 08             	pushl  0x8(%ebp)
80107265:	e8 56 ff ff ff       	call   801071c0 <uva2ka>
    if(pa0 == 0)
8010726a:	83 c4 10             	add    $0x10,%esp
8010726d:	85 c0                	test   %eax,%eax
8010726f:	75 af                	jne    80107220 <copyout+0x20>
  }
  return 0;
}
80107271:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107279:	5b                   	pop    %ebx
8010727a:	5e                   	pop    %esi
8010727b:	5f                   	pop    %edi
8010727c:	5d                   	pop    %ebp
8010727d:	c3                   	ret    
8010727e:	66 90                	xchg   %ax,%ax
80107280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107283:	31 c0                	xor    %eax,%eax
}
80107285:	5b                   	pop    %ebx
80107286:	5e                   	pop    %esi
80107287:	5f                   	pop    %edi
80107288:	5d                   	pop    %ebp
80107289:	c3                   	ret    
8010728a:	66 90                	xchg   %ax,%ax
8010728c:	66 90                	xchg   %ax,%ax
8010728e:	66 90                	xchg   %ax,%ax

80107290 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107290:	f3 0f 1e fb          	endbr32 
80107294:	55                   	push   %ebp
80107295:	89 e5                	mov    %esp,%ebp
80107297:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
8010729a:	68 05 7e 10 80       	push   $0x80107e05
8010729f:	68 e0 55 11 80       	push   $0x801155e0
801072a4:	e8 57 d1 ff ff       	call   80104400 <initlock>
  acquire(&(shm_table.lock));
801072a9:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
801072b0:	e8 5b d2 ff ff       	call   80104510 <acquire>
  for (i = 0; i< 64; i++) {
801072b5:	b8 14 56 11 80       	mov    $0x80115614,%eax
801072ba:	83 c4 10             	add    $0x10,%esp
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
    shm_table.shm_pages[i].id =0;
801072c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
801072c6:	83 c0 0c             	add    $0xc,%eax
801072c9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
801072d0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
801072d7:	3d 14 59 11 80       	cmp    $0x80115914,%eax
801072dc:	75 e2                	jne    801072c0 <shminit+0x30>
  }
  release(&(shm_table.lock));
801072de:	83 ec 0c             	sub    $0xc,%esp
801072e1:	68 e0 55 11 80       	push   $0x801155e0
801072e6:	e8 55 d3 ff ff       	call   80104640 <release>
}
801072eb:	83 c4 10             	add    $0x10,%esp
801072ee:	c9                   	leave  
801072ef:	c3                   	ret    

801072f0 <shm_open>:

int shm_open(int id, char **pointer) {
801072f0:	f3 0f 1e fb          	endbr32 




return 0; //added to remove compiler warning -- you should decide what to return
}
801072f4:	31 c0                	xor    %eax,%eax
801072f6:	c3                   	ret    
801072f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fe:	66 90                	xchg   %ax,%ax

80107300 <shm_close>:


int shm_close(int id) {
80107300:	f3 0f 1e fb          	endbr32 




return 0; //added to remove compiler warning -- you should decide what to return
}
80107304:	31 c0                	xor    %eax,%eax
80107306:	c3                   	ret    
