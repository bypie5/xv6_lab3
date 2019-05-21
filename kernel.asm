
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
8010002d:	b8 d0 2d 10 80       	mov    $0x80102dd0,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 e0 6c 10 	movl   $0x80106ce0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 d0 3f 00 00       	call   80104030 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 e7 6c 10 	movl   $0x80106ce7,0x4(%esp)
8010009b:	80 
8010009c:	e8 7f 3e 00 00       	call   80103f20 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 35 40 00 00       	call   80104120 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 aa 40 00 00       	call   80104210 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ef 3d 00 00       	call   80103f60 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 82 1f 00 00       	call   80102100 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 ee 6c 10 80 	movl   $0x80106cee,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 4b 3e 00 00       	call   80104000 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 37 1f 00 00       	jmp    80102100 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 ff 6c 10 80 	movl   $0x80106cff,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 0a 3e 00 00       	call   80104000 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 be 3d 00 00       	call   80103fc0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 12 3f 00 00       	call   80104120 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 bb 3f 00 00       	jmp    80104210 <release>
    panic("brelse");
80100255:	c7 04 24 06 6d 10 80 	movl   $0x80106d06,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 e9 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 8d 3e 00 00       	call   80104120 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 d3 33 00 00       	call   80103680 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 18 39 00 00       	call   80103be0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 fa 3e 00 00       	call   80104210 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 72 13 00 00       	call   80101690 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 dc 3e 00 00       	call   80104210 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 54 13 00 00       	call   80101690 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 c5 23 00 00       	call   80102740 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 0d 6d 10 80 	movl   $0x80106d0d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 5f 76 10 80 	movl   $0x8010765f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 9c 3c 00 00       	call   80104050 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 21 6d 10 80 	movl   $0x80106d21,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 a2 53 00 00       	call   801057b0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 f2 52 00 00       	call   801057b0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 e6 52 00 00       	call   801057b0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 da 52 00 00       	call   801057b0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ff 3d 00 00       	call   80104300 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 42 3d 00 00       	call   80104260 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 25 6d 10 80 	movl   $0x80106d25,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 50 6d 10 80 	movzbl -0x7fef92b0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 69 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 0d 3b 00 00       	call   80104120 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 d5 3b 00 00       	call   80104210 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 4a 10 00 00       	call   80101690 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 18 3b 00 00       	call   80104210 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 38 6d 10 80       	mov    $0x80106d38,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 84 39 00 00       	call   80104120 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 56 39 00 00       	call   80104120 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 e4 39 00 00       	call   80104210 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 b9 34 00 00       	call   80103d70 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 24 35 00 00       	jmp    80103e50 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 48 6d 10 	movl   $0x80106d48,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 c6 36 00 00       	call   80104030 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 f4 18 00 00       	call   80102290 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 cf 2c 00 00       	call   80103680 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 34 21 00 00       	call   80102af0 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 19 15 00 00       	call   80101ee0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 3f 02 00 00    	je     80100c10 <exec+0x270>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 b7 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 45 0f 00 00       	call   80101940 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 e8 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a08:	e8 53 21 00 00       	call   80102b60 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 8f 5f 00 00       	call   801069c0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ad 0e 00 00       	call   80101940 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 49 5d 00 00       	call   80106820 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 48 5c 00 00       	call   80106760 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 12 5e 00 00       	call   80106940 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 b5 0d 00 00       	call   801018f0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 1b 20 00 00       	call   80102b60 <end_op>
  if((stack_sz = allocuvm(pgdir, (KERNBASE - 1) - PGSIZE, KERNBASE - 1)) == 0)
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 ff ef ff 	movl   $0x7fffefff,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 bd 5c 00 00       	call   80106820 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	0f 84 8d 00 00 00    	je     80100bf8 <exec+0x258>
  sp = stack_sz; 
80100b6b:	89 c3                	mov    %eax,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b70:	8b 00                	mov    (%eax),%eax
80100b72:	85 c0                	test   %eax,%eax
80100b74:	0f 84 92 01 00 00    	je     80100d0c <exec+0x36c>
80100b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b7d:	31 d2                	xor    %edx,%edx
80100b7f:	8d 71 04             	lea    0x4(%ecx),%esi
80100b82:	89 cf                	mov    %ecx,%edi
80100b84:	89 d1                	mov    %edx,%ecx
80100b86:	89 f2                	mov    %esi,%edx
80100b88:	89 ce                	mov    %ecx,%esi
80100b8a:	eb 2a                	jmp    80100bb6 <exec+0x216>
80100b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b90:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100b96:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100b9c:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ba3:	83 c6 01             	add    $0x1,%esi
80100ba6:	8b 02                	mov    (%edx),%eax
80100ba8:	89 d7                	mov    %edx,%edi
80100baa:	85 c0                	test   %eax,%eax
80100bac:	74 7d                	je     80100c2b <exec+0x28b>
80100bae:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bb1:	83 fe 20             	cmp    $0x20,%esi
80100bb4:	74 42                	je     80100bf8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bb6:	89 04 24             	mov    %eax,(%esp)
80100bb9:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bbf:	e8 bc 38 00 00       	call   80104480 <strlen>
80100bc4:	f7 d0                	not    %eax
80100bc6:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bc8:	8b 07                	mov    (%edi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bca:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bcd:	89 04 24             	mov    %eax,(%esp)
80100bd0:	e8 ab 38 00 00       	call   80104480 <strlen>
80100bd5:	83 c0 01             	add    $0x1,%eax
80100bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bdc:	8b 07                	mov    (%edi),%eax
80100bde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100be2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100be6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bec:	89 04 24             	mov    %eax,(%esp)
80100bef:	e8 dc 5f 00 00       	call   80106bd0 <copyout>
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	79 98                	jns    80100b90 <exec+0x1f0>
    freevm(pgdir);
80100bf8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bfe:	89 04 24             	mov    %eax,(%esp)
80100c01:	e8 3a 5d 00 00       	call   80106940 <freevm>
  return -1;
80100c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0b:	e9 02 fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100c10:	e8 4b 1f 00 00       	call   80102b60 <end_op>
    cprintf("exec: fail\n");
80100c15:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
80100c1c:	e8 2f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c26:	e9 e7 fd ff ff       	jmp    80100a12 <exec+0x72>
80100c2b:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100c2d:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c34:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c38:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c3f:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c45:	89 da                	mov    %ebx,%edx
80100c47:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c49:	83 c0 0c             	add    $0xc,%eax
80100c4c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c52:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c60:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c67:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c6a:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c6d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	e8 58 5f 00 00       	call   80106bd0 <copyout>
80100c78:	85 c0                	test   %eax,%eax
80100c7a:	0f 88 78 ff ff ff    	js     80100bf8 <exec+0x258>
  for(last=s=path; *s; s++)
80100c80:	8b 45 08             	mov    0x8(%ebp),%eax
80100c83:	0f b6 10             	movzbl (%eax),%edx
80100c86:	84 d2                	test   %dl,%dl
80100c88:	74 19                	je     80100ca3 <exec+0x303>
80100c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c8d:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100c90:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100c93:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100c96:	0f 44 c8             	cmove  %eax,%ecx
80100c99:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100c9c:	84 d2                	test   %dl,%dl
80100c9e:	75 f0                	jne    80100c90 <exec+0x2f0>
80100ca0:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ca3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cac:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cb3:	00 
80100cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb8:	89 f8                	mov    %edi,%eax
80100cba:	83 c0 6c             	add    $0x6c,%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 7b 37 00 00       	call   80104440 <safestrcpy>
  sz = PGROUNDUP(sz);
80100cc5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100ccb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100cd1:	8b 77 04             	mov    0x4(%edi),%esi
  sz = PGROUNDUP(sz);
80100cd4:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cde:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100ce0:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100ce3:	89 57 04             	mov    %edx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100ce6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cec:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cef:	8b 47 18             	mov    0x18(%edi),%eax
80100cf2:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100cf5:	89 3c 24             	mov    %edi,(%esp)
80100cf8:	e8 c3 58 00 00       	call   801065c0 <switchuvm>
  freevm(oldpgdir);
80100cfd:	89 34 24             	mov    %esi,(%esp)
80100d00:	e8 3b 5c 00 00       	call   80106940 <freevm>
  return 0;
80100d05:	31 c0                	xor    %eax,%eax
80100d07:	e9 06 fd ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d0c:	31 d2                	xor    %edx,%edx
80100d0e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d14:	e9 14 ff ff ff       	jmp    80100c2d <exec+0x28d>
80100d19:	66 90                	xchg   %ax,%ax
80100d1b:	66 90                	xchg   %ax,%ax
80100d1d:	66 90                	xchg   %ax,%ax
80100d1f:	90                   	nop

80100d20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d26:	c7 44 24 04 6d 6d 10 	movl   $0x80106d6d,0x4(%esp)
80100d2d:	80 
80100d2e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d35:	e8 f6 32 00 00       	call   80104030 <initlock>
}
80100d3a:	c9                   	leave  
80100d3b:	c3                   	ret    
80100d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d44:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d49:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d53:	e8 c8 33 00 00       	call   80104120 <acquire>
80100d58:	eb 11                	jmp    80100d6b <filealloc+0x2b>
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d60:	83 c3 18             	add    $0x18,%ebx
80100d63:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d69:	74 25                	je     80100d90 <filealloc+0x50>
    if(f->ref == 0){
80100d6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6e:	85 c0                	test   %eax,%eax
80100d70:	75 ee                	jne    80100d60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d72:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100d79:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d80:	e8 8b 34 00 00       	call   80104210 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d85:	83 c4 14             	add    $0x14,%esp
      return f;
80100d88:	89 d8                	mov    %ebx,%eax
}
80100d8a:	5b                   	pop    %ebx
80100d8b:	5d                   	pop    %ebp
80100d8c:	c3                   	ret    
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100d90:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d97:	e8 74 34 00 00       	call   80104210 <release>
}
80100d9c:	83 c4 14             	add    $0x14,%esp
  return 0;
80100d9f:	31 c0                	xor    %eax,%eax
}
80100da1:	5b                   	pop    %ebx
80100da2:	5d                   	pop    %ebp
80100da3:	c3                   	ret    
80100da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100db0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
80100db4:	83 ec 14             	sub    $0x14,%esp
80100db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dba:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc1:	e8 5a 33 00 00       	call   80104120 <acquire>
  if(f->ref < 1)
80100dc6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc9:	85 c0                	test   %eax,%eax
80100dcb:	7e 1a                	jle    80100de7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dcd:	83 c0 01             	add    $0x1,%eax
80100dd0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dd3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dda:	e8 31 34 00 00       	call   80104210 <release>
  return f;
}
80100ddf:	83 c4 14             	add    $0x14,%esp
80100de2:	89 d8                	mov    %ebx,%eax
80100de4:	5b                   	pop    %ebx
80100de5:	5d                   	pop    %ebp
80100de6:	c3                   	ret    
    panic("filedup");
80100de7:	c7 04 24 74 6d 10 80 	movl   $0x80106d74,(%esp)
80100dee:	e8 6d f5 ff ff       	call   80100360 <panic>
80100df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	83 ec 1c             	sub    $0x1c,%esp
80100e09:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e0c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e13:	e8 08 33 00 00       	call   80104120 <acquire>
  if(f->ref < 1)
80100e18:	8b 57 04             	mov    0x4(%edi),%edx
80100e1b:	85 d2                	test   %edx,%edx
80100e1d:	0f 8e 89 00 00 00    	jle    80100eac <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e23:	83 ea 01             	sub    $0x1,%edx
80100e26:	85 d2                	test   %edx,%edx
80100e28:	89 57 04             	mov    %edx,0x4(%edi)
80100e2b:	74 13                	je     80100e40 <fileclose+0x40>
    release(&ftable.lock);
80100e2d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e34:	83 c4 1c             	add    $0x1c,%esp
80100e37:	5b                   	pop    %ebx
80100e38:	5e                   	pop    %esi
80100e39:	5f                   	pop    %edi
80100e3a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e3b:	e9 d0 33 00 00       	jmp    80104210 <release>
  ff = *f;
80100e40:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e44:	8b 37                	mov    (%edi),%esi
80100e46:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e49:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e4f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e52:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e55:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e5f:	e8 ac 33 00 00       	call   80104210 <release>
  if(ff.type == FD_PIPE)
80100e64:	83 fe 01             	cmp    $0x1,%esi
80100e67:	74 0f                	je     80100e78 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e69:	83 fe 02             	cmp    $0x2,%esi
80100e6c:	74 22                	je     80100e90 <fileclose+0x90>
}
80100e6e:	83 c4 1c             	add    $0x1c,%esp
80100e71:	5b                   	pop    %ebx
80100e72:	5e                   	pop    %esi
80100e73:	5f                   	pop    %edi
80100e74:	5d                   	pop    %ebp
80100e75:	c3                   	ret    
80100e76:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100e78:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e7c:	89 1c 24             	mov    %ebx,(%esp)
80100e7f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e83:	e8 b8 23 00 00       	call   80103240 <pipeclose>
80100e88:	eb e4                	jmp    80100e6e <fileclose+0x6e>
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100e90:	e8 5b 1c 00 00       	call   80102af0 <begin_op>
    iput(ff.ip);
80100e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e98:	89 04 24             	mov    %eax,(%esp)
80100e9b:	e8 10 09 00 00       	call   801017b0 <iput>
}
80100ea0:	83 c4 1c             	add    $0x1c,%esp
80100ea3:	5b                   	pop    %ebx
80100ea4:	5e                   	pop    %esi
80100ea5:	5f                   	pop    %edi
80100ea6:	5d                   	pop    %ebp
    end_op();
80100ea7:	e9 b4 1c 00 00       	jmp    80102b60 <end_op>
    panic("fileclose");
80100eac:	c7 04 24 7c 6d 10 80 	movl   $0x80106d7c,(%esp)
80100eb3:	e8 a8 f4 ff ff       	call   80100360 <panic>
80100eb8:	90                   	nop
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 14             	sub    $0x14,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ecd:	75 31                	jne    80100f00 <filestat+0x40>
    ilock(f->ip);
80100ecf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ed2:	89 04 24             	mov    %eax,(%esp)
80100ed5:	e8 b6 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100eda:	8b 45 0c             	mov    0xc(%ebp),%eax
80100edd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee4:	89 04 24             	mov    %eax,(%esp)
80100ee7:	e8 24 0a 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100eec:	8b 43 10             	mov    0x10(%ebx),%eax
80100eef:	89 04 24             	mov    %eax,(%esp)
80100ef2:	e8 79 08 00 00       	call   80101770 <iunlock>
    return 0;
  }
  return -1;
}
80100ef7:	83 c4 14             	add    $0x14,%esp
    return 0;
80100efa:	31 c0                	xor    %eax,%eax
}
80100efc:	5b                   	pop    %ebx
80100efd:	5d                   	pop    %ebp
80100efe:	c3                   	ret    
80100eff:	90                   	nop
80100f00:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f08:	5b                   	pop    %ebx
80100f09:	5d                   	pop    %ebp
80100f0a:	c3                   	ret    
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 1c             	sub    $0x1c,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f22:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f26:	74 68                	je     80100f90 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f28:	8b 03                	mov    (%ebx),%eax
80100f2a:	83 f8 01             	cmp    $0x1,%eax
80100f2d:	74 49                	je     80100f78 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f2f:	83 f8 02             	cmp    $0x2,%eax
80100f32:	75 63                	jne    80100f97 <fileread+0x87>
    ilock(f->ip);
80100f34:	8b 43 10             	mov    0x10(%ebx),%eax
80100f37:	89 04 24             	mov    %eax,(%esp)
80100f3a:	e8 51 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f3f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f43:	8b 43 14             	mov    0x14(%ebx),%eax
80100f46:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f4a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f4e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f51:	89 04 24             	mov    %eax,(%esp)
80100f54:	e8 e7 09 00 00       	call   80101940 <readi>
80100f59:	85 c0                	test   %eax,%eax
80100f5b:	89 c6                	mov    %eax,%esi
80100f5d:	7e 03                	jle    80100f62 <fileread+0x52>
      f->off += r;
80100f5f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f62:	8b 43 10             	mov    0x10(%ebx),%eax
80100f65:	89 04 24             	mov    %eax,(%esp)
80100f68:	e8 03 08 00 00       	call   80101770 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f6f:	83 c4 1c             	add    $0x1c,%esp
80100f72:	5b                   	pop    %ebx
80100f73:	5e                   	pop    %esi
80100f74:	5f                   	pop    %edi
80100f75:	5d                   	pop    %ebp
80100f76:	c3                   	ret    
80100f77:	90                   	nop
    return piperead(f->pipe, addr, n);
80100f78:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f7b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f7e:	83 c4 1c             	add    $0x1c,%esp
80100f81:	5b                   	pop    %ebx
80100f82:	5e                   	pop    %esi
80100f83:	5f                   	pop    %edi
80100f84:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f85:	e9 36 24 00 00       	jmp    801033c0 <piperead>
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f95:	eb d8                	jmp    80100f6f <fileread+0x5f>
  panic("fileread");
80100f97:	c7 04 24 86 6d 10 80 	movl   $0x80106d86,(%esp)
80100f9e:	e8 bd f3 ff ff       	call   80100360 <panic>
80100fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fb0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	57                   	push   %edi
80100fb4:	56                   	push   %esi
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 2c             	sub    $0x2c,%esp
80100fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fc5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fcc:	0f 84 ae 00 00 00    	je     80101080 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fd2:	8b 07                	mov    (%edi),%eax
80100fd4:	83 f8 01             	cmp    $0x1,%eax
80100fd7:	0f 84 c2 00 00 00    	je     8010109f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdd:	83 f8 02             	cmp    $0x2,%eax
80100fe0:	0f 85 d7 00 00 00    	jne    801010bd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe9:	31 db                	xor    %ebx,%ebx
80100feb:	85 c0                	test   %eax,%eax
80100fed:	7f 31                	jg     80101020 <filewrite+0x70>
80100fef:	e9 9c 00 00 00       	jmp    80101090 <filewrite+0xe0>
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100ff8:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
80100ffb:	01 47 14             	add    %eax,0x14(%edi)
80100ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101001:	89 0c 24             	mov    %ecx,(%esp)
80101004:	e8 67 07 00 00       	call   80101770 <iunlock>
      end_op();
80101009:	e8 52 1b 00 00       	call   80102b60 <end_op>
8010100e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101011:	39 f0                	cmp    %esi,%eax
80101013:	0f 85 98 00 00 00    	jne    801010b1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101019:	01 c3                	add    %eax,%ebx
    while(i < n){
8010101b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010101e:	7e 70                	jle    80101090 <filewrite+0xe0>
      int n1 = n - i;
80101020:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101023:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101028:	29 de                	sub    %ebx,%esi
8010102a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101030:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101033:	e8 b8 1a 00 00       	call   80102af0 <begin_op>
      ilock(f->ip);
80101038:	8b 47 10             	mov    0x10(%edi),%eax
8010103b:	89 04 24             	mov    %eax,(%esp)
8010103e:	e8 4d 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101043:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101047:	8b 47 14             	mov    0x14(%edi),%eax
8010104a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010104e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101051:	01 d8                	add    %ebx,%eax
80101053:	89 44 24 04          	mov    %eax,0x4(%esp)
80101057:	8b 47 10             	mov    0x10(%edi),%eax
8010105a:	89 04 24             	mov    %eax,(%esp)
8010105d:	e8 de 09 00 00       	call   80101a40 <writei>
80101062:	85 c0                	test   %eax,%eax
80101064:	7f 92                	jg     80100ff8 <filewrite+0x48>
      iunlock(f->ip);
80101066:	8b 4f 10             	mov    0x10(%edi),%ecx
80101069:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010106c:	89 0c 24             	mov    %ecx,(%esp)
8010106f:	e8 fc 06 00 00       	call   80101770 <iunlock>
      end_op();
80101074:	e8 e7 1a 00 00       	call   80102b60 <end_op>
      if(r < 0)
80101079:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107c:	85 c0                	test   %eax,%eax
8010107e:	74 91                	je     80101011 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101080:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	5b                   	pop    %ebx
80101089:	5e                   	pop    %esi
8010108a:	5f                   	pop    %edi
8010108b:	5d                   	pop    %ebp
8010108c:	c3                   	ret    
8010108d:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
80101090:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101093:	89 d8                	mov    %ebx,%eax
80101095:	75 e9                	jne    80101080 <filewrite+0xd0>
}
80101097:	83 c4 2c             	add    $0x2c,%esp
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
8010109e:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010109f:	8b 47 0c             	mov    0xc(%edi),%eax
801010a2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a5:	83 c4 2c             	add    $0x2c,%esp
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ac:	e9 1f 22 00 00       	jmp    801032d0 <pipewrite>
        panic("short filewrite");
801010b1:	c7 04 24 8f 6d 10 80 	movl   $0x80106d8f,(%esp)
801010b8:	e8 a3 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010bd:	c7 04 24 95 6d 10 80 	movl   $0x80106d95,(%esp)
801010c4:	e8 97 f2 ff ff       	call   80100360 <panic>
801010c9:	66 90                	xchg   %ax,%ax
801010cb:	66 90                	xchg   %ax,%ax
801010cd:	66 90                	xchg   %ax,%ax
801010cf:	90                   	nop

801010d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 2c             	sub    $0x2c,%esp
801010d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010dc:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010e1:	85 c0                	test   %eax,%eax
801010e3:	0f 84 8c 00 00 00    	je     80101175 <balloc+0xa5>
801010e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010f0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010f3:	89 f0                	mov    %esi,%eax
801010f5:	c1 f8 0c             	sar    $0xc,%eax
801010f8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80101102:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101105:	89 04 24             	mov    %eax,(%esp)
80101108:	e8 c3 ef ff ff       	call   801000d0 <bread>
8010110d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101110:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101115:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101118:	31 c0                	xor    %eax,%eax
8010111a:	eb 33                	jmp    8010114f <balloc+0x7f>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101120:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101123:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101125:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101127:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010112a:	83 e1 07             	and    $0x7,%ecx
8010112d:	bf 01 00 00 00       	mov    $0x1,%edi
80101132:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101134:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101139:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113b:	0f b6 fb             	movzbl %bl,%edi
8010113e:	85 cf                	test   %ecx,%edi
80101140:	74 46                	je     80101188 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101142:	83 c0 01             	add    $0x1,%eax
80101145:	83 c6 01             	add    $0x1,%esi
80101148:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010114d:	74 05                	je     80101154 <balloc+0x84>
8010114f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101152:	72 cc                	jb     80101120 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101157:	89 04 24             	mov    %eax,(%esp)
8010115a:	e8 81 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010115f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101166:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101169:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010116f:	0f 82 7b ff ff ff    	jb     801010f0 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101175:	c7 04 24 9f 6d 10 80 	movl   $0x80106d9f,(%esp)
8010117c:	e8 df f1 ff ff       	call   80100360 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101188:	09 d9                	or     %ebx,%ecx
8010118a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010118d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101191:	89 1c 24             	mov    %ebx,(%esp)
80101194:	e8 f7 1a 00 00       	call   80102c90 <log_write>
        brelse(bp);
80101199:	89 1c 24             	mov    %ebx,(%esp)
8010119c:	e8 3f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011a4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011a8:	89 04 24             	mov    %eax,(%esp)
801011ab:	e8 20 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011b7:	00 
801011b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011bf:	00 
  bp = bread(dev, bno);
801011c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011c5:	89 04 24             	mov    %eax,(%esp)
801011c8:	e8 93 30 00 00       	call   80104260 <memset>
  log_write(bp);
801011cd:	89 1c 24             	mov    %ebx,(%esp)
801011d0:	e8 bb 1a 00 00       	call   80102c90 <log_write>
  brelse(bp);
801011d5:	89 1c 24             	mov    %ebx,(%esp)
801011d8:	e8 03 f0 ff ff       	call   801001e0 <brelse>
}
801011dd:	83 c4 2c             	add    $0x2c,%esp
801011e0:	89 f0                	mov    %esi,%eax
801011e2:	5b                   	pop    %ebx
801011e3:	5e                   	pop    %esi
801011e4:	5f                   	pop    %edi
801011e5:	5d                   	pop    %ebp
801011e6:	c3                   	ret    
801011e7:	89 f6                	mov    %esi,%esi
801011e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	89 c7                	mov    %eax,%edi
801011f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f7:	31 f6                	xor    %esi,%esi
{
801011f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801011ff:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101202:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101209:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010120c:	e8 0f 2f 00 00       	call   80104120 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101211:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101214:	eb 14                	jmp    8010122a <iget+0x3a>
80101216:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101218:	85 f6                	test   %esi,%esi
8010121a:	74 3c                	je     80101258 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101222:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101228:	74 46                	je     80101270 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010122a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010122d:	85 c9                	test   %ecx,%ecx
8010122f:	7e e7                	jle    80101218 <iget+0x28>
80101231:	39 3b                	cmp    %edi,(%ebx)
80101233:	75 e3                	jne    80101218 <iget+0x28>
80101235:	39 53 04             	cmp    %edx,0x4(%ebx)
80101238:	75 de                	jne    80101218 <iget+0x28>
      ip->ref++;
8010123a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010123d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010123f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101246:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101249:	e8 c2 2f 00 00       	call   80104210 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010124e:	83 c4 1c             	add    $0x1c,%esp
80101251:	89 f0                	mov    %esi,%eax
80101253:	5b                   	pop    %ebx
80101254:	5e                   	pop    %esi
80101255:	5f                   	pop    %edi
80101256:	5d                   	pop    %ebp
80101257:	c3                   	ret    
80101258:	85 c9                	test   %ecx,%ecx
8010125a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101263:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101269:	75 bf                	jne    8010122a <iget+0x3a>
8010126b:	90                   	nop
8010126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101270:	85 f6                	test   %esi,%esi
80101272:	74 29                	je     8010129d <iget+0xad>
  ip->dev = dev;
80101274:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101276:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101279:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101280:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101287:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010128e:	e8 7d 2f 00 00       	call   80104210 <release>
}
80101293:	83 c4 1c             	add    $0x1c,%esp
80101296:	89 f0                	mov    %esi,%eax
80101298:	5b                   	pop    %ebx
80101299:	5e                   	pop    %esi
8010129a:	5f                   	pop    %edi
8010129b:	5d                   	pop    %ebp
8010129c:	c3                   	ret    
    panic("iget: no inodes");
8010129d:	c7 04 24 b5 6d 10 80 	movl   $0x80106db5,(%esp)
801012a4:	e8 b7 f0 ff ff       	call   80100360 <panic>
801012a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	89 c3                	mov    %eax,%ebx
801012b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012bb:	83 fa 0b             	cmp    $0xb,%edx
801012be:	77 18                	ja     801012d8 <bmap+0x28>
801012c0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012c3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012c6:	85 c0                	test   %eax,%eax
801012c8:	74 66                	je     80101330 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ca:	83 c4 1c             	add    $0x1c,%esp
801012cd:	5b                   	pop    %ebx
801012ce:	5e                   	pop    %esi
801012cf:	5f                   	pop    %edi
801012d0:	5d                   	pop    %ebp
801012d1:	c3                   	ret    
801012d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
801012d8:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801012db:	83 fe 7f             	cmp    $0x7f,%esi
801012de:	77 77                	ja     80101357 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801012e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 5e                	je     80101348 <bmap+0x98>
    bp = bread(ip->dev, addr);
801012ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801012ee:	8b 03                	mov    (%ebx),%eax
801012f0:	89 04 24             	mov    %eax,(%esp)
801012f3:	e8 d8 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801012f8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801012fc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801012fe:	8b 32                	mov    (%edx),%esi
80101300:	85 f6                	test   %esi,%esi
80101302:	75 19                	jne    8010131d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101304:	8b 03                	mov    (%ebx),%eax
80101306:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101309:	e8 c2 fd ff ff       	call   801010d0 <balloc>
8010130e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101311:	89 02                	mov    %eax,(%edx)
80101313:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101315:	89 3c 24             	mov    %edi,(%esp)
80101318:	e8 73 19 00 00       	call   80102c90 <log_write>
    brelse(bp);
8010131d:	89 3c 24             	mov    %edi,(%esp)
80101320:	e8 bb ee ff ff       	call   801001e0 <brelse>
}
80101325:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101328:	89 f0                	mov    %esi,%eax
}
8010132a:	5b                   	pop    %ebx
8010132b:	5e                   	pop    %esi
8010132c:	5f                   	pop    %edi
8010132d:	5d                   	pop    %ebp
8010132e:	c3                   	ret    
8010132f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101330:	8b 03                	mov    (%ebx),%eax
80101332:	e8 99 fd ff ff       	call   801010d0 <balloc>
80101337:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010133a:	83 c4 1c             	add    $0x1c,%esp
8010133d:	5b                   	pop    %ebx
8010133e:	5e                   	pop    %esi
8010133f:	5f                   	pop    %edi
80101340:	5d                   	pop    %ebp
80101341:	c3                   	ret    
80101342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101348:	8b 03                	mov    (%ebx),%eax
8010134a:	e8 81 fd ff ff       	call   801010d0 <balloc>
8010134f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101355:	eb 93                	jmp    801012ea <bmap+0x3a>
  panic("bmap: out of range");
80101357:	c7 04 24 c5 6d 10 80 	movl   $0x80106dc5,(%esp)
8010135e:	e8 fd ef ff ff       	call   80100360 <panic>
80101363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101370 <readsb>:
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	56                   	push   %esi
80101374:	53                   	push   %ebx
80101375:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101378:	8b 45 08             	mov    0x8(%ebp),%eax
8010137b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101382:	00 
{
80101383:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101386:	89 04 24             	mov    %eax,(%esp)
80101389:	e8 42 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010138e:	89 34 24             	mov    %esi,(%esp)
80101391:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101398:	00 
  bp = bread(dev, 1);
80101399:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010139b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010139e:	89 44 24 04          	mov    %eax,0x4(%esp)
801013a2:	e8 59 2f 00 00       	call   80104300 <memmove>
  brelse(bp);
801013a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013aa:	83 c4 10             	add    $0x10,%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5d                   	pop    %ebp
  brelse(bp);
801013b0:	e9 2b ee ff ff       	jmp    801001e0 <brelse>
801013b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <bfree>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	89 d7                	mov    %edx,%edi
801013c6:	56                   	push   %esi
801013c7:	53                   	push   %ebx
801013c8:	89 c3                	mov    %eax,%ebx
801013ca:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801013cd:	89 04 24             	mov    %eax,(%esp)
801013d0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013d7:	80 
801013d8:	e8 93 ff ff ff       	call   80101370 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013dd:	89 fa                	mov    %edi,%edx
801013df:	c1 ea 0c             	shr    $0xc,%edx
801013e2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013e8:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
801013eb:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801013f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801013f4:	e8 d7 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801013f9:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
801013fb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101401:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101403:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101406:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101409:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010140b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010140d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101412:	0f b6 c8             	movzbl %al,%ecx
80101415:	85 d9                	test   %ebx,%ecx
80101417:	74 20                	je     80101439 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101419:	f7 d3                	not    %ebx
8010141b:	21 c3                	and    %eax,%ebx
8010141d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101421:	89 34 24             	mov    %esi,(%esp)
80101424:	e8 67 18 00 00       	call   80102c90 <log_write>
  brelse(bp);
80101429:	89 34 24             	mov    %esi,(%esp)
8010142c:	e8 af ed ff ff       	call   801001e0 <brelse>
}
80101431:	83 c4 1c             	add    $0x1c,%esp
80101434:	5b                   	pop    %ebx
80101435:	5e                   	pop    %esi
80101436:	5f                   	pop    %edi
80101437:	5d                   	pop    %ebp
80101438:	c3                   	ret    
    panic("freeing free block");
80101439:	c7 04 24 d8 6d 10 80 	movl   $0x80106dd8,(%esp)
80101440:	e8 1b ef ff ff       	call   80100360 <panic>
80101445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101450 <iinit>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101459:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010145c:	c7 44 24 04 eb 6d 10 	movl   $0x80106deb,0x4(%esp)
80101463:	80 
80101464:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010146b:	e8 c0 2b 00 00       	call   80104030 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101470:	89 1c 24             	mov    %ebx,(%esp)
80101473:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101479:	c7 44 24 04 f2 6d 10 	movl   $0x80106df2,0x4(%esp)
80101480:	80 
80101481:	e8 9a 2a 00 00       	call   80103f20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101486:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010148c:	75 e2                	jne    80101470 <iinit+0x20>
  readsb(dev, &sb);
8010148e:	8b 45 08             	mov    0x8(%ebp),%eax
80101491:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101498:	80 
80101499:	89 04 24             	mov    %eax,(%esp)
8010149c:	e8 cf fe ff ff       	call   80101370 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014a1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014a6:	c7 04 24 58 6e 10 80 	movl   $0x80106e58,(%esp)
801014ad:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014b1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014b6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ba:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014bf:	89 44 24 14          	mov    %eax,0x14(%esp)
801014c3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014c8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014cc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014d5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014da:	89 44 24 08          	mov    %eax,0x8(%esp)
801014de:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e7:	e8 64 f1 ff ff       	call   80100650 <cprintf>
}
801014ec:	83 c4 24             	add    $0x24,%esp
801014ef:	5b                   	pop    %ebx
801014f0:	5d                   	pop    %ebp
801014f1:	c3                   	ret    
801014f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101500 <ialloc>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 2c             	sub    $0x2c,%esp
80101509:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010150c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101513:	8b 7d 08             	mov    0x8(%ebp),%edi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 a2 00 00 00    	jbe    801015c1 <ialloc+0xc1>
8010151f:	be 01 00 00 00       	mov    $0x1,%esi
80101524:	bb 01 00 00 00       	mov    $0x1,%ebx
80101529:	eb 1a                	jmp    80101545 <ialloc+0x45>
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101530:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101536:	e8 a5 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010153b:	89 de                	mov    %ebx,%esi
8010153d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101543:	73 7c                	jae    801015c1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101545:	89 f0                	mov    %esi,%eax
80101547:	c1 e8 03             	shr    $0x3,%eax
8010154a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101550:	89 3c 24             	mov    %edi,(%esp)
80101553:	89 44 24 04          	mov    %eax,0x4(%esp)
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 f0                	mov    %esi,%eax
80101560:	83 e0 07             	and    $0x7,%eax
80101563:	c1 e0 06             	shl    $0x6,%eax
80101566:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010156e:	75 c0                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101570:	89 0c 24             	mov    %ecx,(%esp)
80101573:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010157a:	00 
8010157b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101582:	00 
80101583:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	e8 d2 2c 00 00       	call   80104260 <memset>
      dip->type = type;
8010158e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101592:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
80101595:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101598:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
8010159b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159e:	89 14 24             	mov    %edx,(%esp)
801015a1:	e8 ea 16 00 00       	call   80102c90 <log_write>
      brelse(bp);
801015a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015a9:	89 14 24             	mov    %edx,(%esp)
801015ac:	e8 2f ec ff ff       	call   801001e0 <brelse>
}
801015b1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015b4:	89 f2                	mov    %esi,%edx
}
801015b6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015b7:	89 f8                	mov    %edi,%eax
}
801015b9:	5e                   	pop    %esi
801015ba:	5f                   	pop    %edi
801015bb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bc:	e9 2f fc ff ff       	jmp    801011f0 <iget>
  panic("ialloc: no inodes");
801015c1:	c7 04 24 f8 6d 10 80 	movl   $0x80106df8,(%esp)
801015c8:	e8 93 ed ff ff       	call   80100360 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	83 ec 10             	sub    $0x10,%esp
801015d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801015ee:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801015f1:	89 04 24             	mov    %eax,(%esp)
801015f4:	e8 d7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f9:	8b 53 a8             	mov    -0x58(%ebx),%edx
801015fc:	83 e2 07             	and    $0x7,%edx
801015ff:	c1 e2 06             	shl    $0x6,%edx
80101602:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101606:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101608:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010160f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101613:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101617:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010161b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010161f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101623:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101627:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010162b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010162e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101631:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101635:	89 14 24             	mov    %edx,(%esp)
80101638:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010163f:	00 
80101640:	e8 bb 2c 00 00       	call   80104300 <memmove>
  log_write(bp);
80101645:	89 34 24             	mov    %esi,(%esp)
80101648:	e8 43 16 00 00       	call   80102c90 <log_write>
  brelse(bp);
8010164d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101650:	83 c4 10             	add    $0x10,%esp
80101653:	5b                   	pop    %ebx
80101654:	5e                   	pop    %esi
80101655:	5d                   	pop    %ebp
  brelse(bp);
80101656:	e9 85 eb ff ff       	jmp    801001e0 <brelse>
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 14             	sub    $0x14,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101671:	e8 aa 2a 00 00       	call   80104120 <acquire>
  ip->ref++;
80101676:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010167a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101681:	e8 8a 2b 00 00       	call   80104210 <release>
}
80101686:	83 c4 14             	add    $0x14,%esp
80101689:	89 d8                	mov    %ebx,%eax
8010168b:	5b                   	pop    %ebx
8010168c:	5d                   	pop    %ebp
8010168d:	c3                   	ret    
8010168e:	66 90                	xchg   %ax,%ax

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	83 ec 10             	sub    $0x10,%esp
80101698:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010169b:	85 db                	test   %ebx,%ebx
8010169d:	0f 84 b3 00 00 00    	je     80101756 <ilock+0xc6>
801016a3:	8b 53 08             	mov    0x8(%ebx),%edx
801016a6:	85 d2                	test   %edx,%edx
801016a8:	0f 8e a8 00 00 00    	jle    80101756 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801016b1:	89 04 24             	mov    %eax,(%esp)
801016b4:	e8 a7 28 00 00       	call   80103f60 <acquiresleep>
  if(ip->valid == 0){
801016b9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016bc:	85 c0                	test   %eax,%eax
801016be:	74 08                	je     801016c8 <ilock+0x38>
}
801016c0:	83 c4 10             	add    $0x10,%esp
801016c3:	5b                   	pop    %ebx
801016c4:	5e                   	pop    %esi
801016c5:	5d                   	pop    %ebp
801016c6:	c3                   	ret    
801016c7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c8:	8b 43 04             	mov    0x4(%ebx),%eax
801016cb:	c1 e8 03             	shr    $0x3,%eax
801016ce:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016d8:	8b 03                	mov    (%ebx),%eax
801016da:	89 04 24             	mov    %eax,(%esp)
801016dd:	e8 ee e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e2:	8b 53 04             	mov    0x4(%ebx),%edx
801016e5:	83 e2 07             	and    $0x7,%edx
801016e8:	c1 e2 06             	shl    $0x6,%edx
801016eb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ef:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
801016f1:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f4:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
801016f7:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
801016fb:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801016ff:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101703:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101707:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010170b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010170f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101713:	8b 42 fc             	mov    -0x4(%edx),%eax
80101716:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101719:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010171c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101720:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101727:	00 
80101728:	89 04 24             	mov    %eax,(%esp)
8010172b:	e8 d0 2b 00 00       	call   80104300 <memmove>
    brelse(bp);
80101730:	89 34 24             	mov    %esi,(%esp)
80101733:	e8 a8 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 76 ff ff ff    	jne    801016c0 <ilock+0x30>
      panic("ilock: no type");
8010174a:	c7 04 24 10 6e 10 80 	movl   $0x80106e10,(%esp)
80101751:	e8 0a ec ff ff       	call   80100360 <panic>
    panic("ilock");
80101756:	c7 04 24 0a 6e 10 80 	movl   $0x80106e0a,(%esp)
8010175d:	e8 fe eb ff ff       	call   80100360 <panic>
80101762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	83 ec 10             	sub    $0x10,%esp
80101778:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010177b:	85 db                	test   %ebx,%ebx
8010177d:	74 24                	je     801017a3 <iunlock+0x33>
8010177f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101782:	89 34 24             	mov    %esi,(%esp)
80101785:	e8 76 28 00 00       	call   80104000 <holdingsleep>
8010178a:	85 c0                	test   %eax,%eax
8010178c:	74 15                	je     801017a3 <iunlock+0x33>
8010178e:	8b 43 08             	mov    0x8(%ebx),%eax
80101791:	85 c0                	test   %eax,%eax
80101793:	7e 0e                	jle    801017a3 <iunlock+0x33>
  releasesleep(&ip->lock);
80101795:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	5b                   	pop    %ebx
8010179c:	5e                   	pop    %esi
8010179d:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179e:	e9 1d 28 00 00       	jmp    80103fc0 <releasesleep>
    panic("iunlock");
801017a3:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801017aa:	e8 b1 eb ff ff       	call   80100360 <panic>
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 1c             	sub    $0x1c,%esp
801017b9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017bc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017bf:	89 3c 24             	mov    %edi,(%esp)
801017c2:	e8 99 27 00 00       	call   80103f60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ca:	85 d2                	test   %edx,%edx
801017cc:	74 07                	je     801017d5 <iput+0x25>
801017ce:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017d3:	74 2b                	je     80101800 <iput+0x50>
  releasesleep(&ip->lock);
801017d5:	89 3c 24             	mov    %edi,(%esp)
801017d8:	e8 e3 27 00 00       	call   80103fc0 <releasesleep>
  acquire(&icache.lock);
801017dd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e4:	e8 37 29 00 00       	call   80104120 <acquire>
  ip->ref--;
801017e9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017ed:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f4:	83 c4 1c             	add    $0x1c,%esp
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
  release(&icache.lock);
801017fb:	e9 10 2a 00 00       	jmp    80104210 <release>
    acquire(&icache.lock);
80101800:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101807:	e8 14 29 00 00       	call   80104120 <acquire>
    int r = ip->ref;
8010180c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010180f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101816:	e8 f5 29 00 00       	call   80104210 <release>
    if(r == 1){
8010181b:	83 fb 01             	cmp    $0x1,%ebx
8010181e:	75 b5                	jne    801017d5 <iput+0x25>
80101820:	8d 4e 30             	lea    0x30(%esi),%ecx
80101823:	89 f3                	mov    %esi,%ebx
80101825:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x87>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xa0>
    if(ip->addrs[i]){
80101837:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010183a:	85 d2                	test   %edx,%edx
8010183c:	74 f2                	je     80101830 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010183e:	8b 06                	mov    (%esi),%eax
80101840:	e8 7b fb ff ff       	call   801013c0 <bfree>
      ip->addrs[i] = 0;
80101845:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010184c:	eb e2                	jmp    80101830 <iput+0x80>
8010184e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 2b                	jne    80101888 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010185d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101864:	89 34 24             	mov    %esi,(%esp)
80101867:	e8 64 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010186c:	31 c0                	xor    %eax,%eax
8010186e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101872:	89 34 24             	mov    %esi,(%esp)
80101875:	e8 56 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010187a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101881:	e9 4f ff ff ff       	jmp    801017d5 <iput+0x25>
80101886:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101888:	89 44 24 04          	mov    %eax,0x4(%esp)
8010188c:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
8010188e:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	89 04 24             	mov    %eax,(%esp)
80101893:	e8 38 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101898:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
8010189b:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010189e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018a1:	89 cf                	mov    %ecx,%edi
801018a3:	31 c0                	xor    %eax,%eax
801018a5:	eb 0e                	jmp    801018b5 <iput+0x105>
801018a7:	90                   	nop
801018a8:	83 c3 01             	add    $0x1,%ebx
801018ab:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	74 10                	je     801018c5 <iput+0x115>
      if(a[j])
801018b5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018b8:	85 d2                	test   %edx,%edx
801018ba:	74 ec                	je     801018a8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018bc:	8b 06                	mov    (%esi),%eax
801018be:	e8 fd fa ff ff       	call   801013c0 <bfree>
801018c3:	eb e3                	jmp    801018a8 <iput+0xf8>
    brelse(bp);
801018c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018cb:	89 04 24             	mov    %eax,(%esp)
801018ce:	e8 0d e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018d3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d9:	8b 06                	mov    (%esi),%eax
801018db:	e8 e0 fa ff ff       	call   801013c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e7:	00 00 00 
801018ea:	e9 6e ff ff ff       	jmp    8010185d <iput+0xad>
801018ef:	90                   	nop

801018f0 <iunlockput>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 14             	sub    $0x14,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 6e fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101905:	83 c4 14             	add    $0x14,%esp
80101908:	5b                   	pop    %ebx
80101909:	5d                   	pop    %ebp
  iput(ip);
8010190a:	e9 a1 fe ff ff       	jmp    801017b0 <iput>
8010190f:	90                   	nop

80101910 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010194c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
80101952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101955:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101958:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010195d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101960:	0f 84 aa 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101966:	8b 47 58             	mov    0x58(%edi),%eax
80101969:	39 f0                	cmp    %esi,%eax
8010196b:	0f 82 c7 00 00 00    	jb     80101a38 <readi+0xf8>
80101971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101974:	89 da                	mov    %ebx,%edx
80101976:	01 f2                	add    %esi,%edx
80101978:	0f 82 ba 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010197e:	89 c1                	mov    %eax,%ecx
80101980:	29 f1                	sub    %esi,%ecx
80101982:	39 d0                	cmp    %edx,%eax
80101984:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101987:	31 c0                	xor    %eax,%eax
80101989:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
8010198b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198e:	74 70                	je     80101a00 <readi+0xc0>
80101990:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101993:	89 c7                	mov    %eax,%edi
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101998:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010199b:	89 f2                	mov    %esi,%edx
8010199d:	c1 ea 09             	shr    $0x9,%edx
801019a0:	89 d8                	mov    %ebx,%eax
801019a2:	e8 09 f9 ff ff       	call   801012b0 <bmap>
801019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019ab:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ad:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b2:	89 04 24             	mov    %eax,(%esp)
801019b5:	e8 16 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019bd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	89 f0                	mov    %esi,%eax
801019c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ce:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019d7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	01 df                	add    %ebx,%edi
801019e0:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019e5:	89 04 24             	mov    %eax,(%esp)
801019e8:	e8 13 29 00 00       	call   80104300 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019fe:	77 98                	ja     80101998 <readi+0x58>
  }
  return n;
80101a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a03:	83 c4 2c             	add    $0x2c,%esp
80101a06:	5b                   	pop    %ebx
80101a07:	5e                   	pop    %esi
80101a08:	5f                   	pop    %edi
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a2b:	83 c4 2c             	add    $0x2c,%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a32:	ff e0                	jmp    *%eax
80101a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c4                	jmp    80101a03 <readi+0xc3>
80101a3f:	90                   	nop

80101a40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 2c             	sub    $0x2c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 e3 00 00 00    	jb     80101b58 <writei+0x118>
80101a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a78:	89 c8                	mov    %ecx,%eax
80101a7a:	01 f0                	add    %esi,%eax
80101a7c:	0f 82 d6 00 00 00    	jb     80101b58 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a87:	0f 87 cb 00 00 00    	ja     80101b58 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8d:	85 c9                	test   %ecx,%ecx
80101a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a96:	74 77                	je     80101b0f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a98:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a9b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa2:	c1 ea 09             	shr    $0x9,%edx
80101aa5:	89 f8                	mov    %edi,%eax
80101aa7:	e8 04 f8 ff ff       	call   801012b0 <bmap>
80101aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab0:	8b 07                	mov    (%edi),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 16 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101abd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101acc:	29 c3                	sub    %eax,%ebx
80101ace:	39 cb                	cmp    %ecx,%ebx
80101ad0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae1:	89 04 24             	mov    %eax,(%esp)
80101ae4:	e8 17 28 00 00       	call   80104300 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 9f 11 00 00       	call   80102c90 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aff:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b02:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b05:	77 91                	ja     80101a98 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0d:	72 39                	jb     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b12:	83 c4 2c             	add    $0x2c,%esp
80101b15:	5b                   	pop    %ebx
80101b16:	5e                   	pop    %esi
80101b17:	5f                   	pop    %edi
80101b18:	5d                   	pop    %ebp
80101b19:	c3                   	ret    
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 2e                	ja     80101b58 <writei+0x118>
80101b2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 23                	je     80101b58 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b4e:	89 04 24             	mov    %eax,(%esp)
80101b51:	e8 7a fa ff ff       	call   801015d0 <iupdate>
80101b56:	eb b7                	jmp    80101b0f <writei+0xcf>
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b60:	5b                   	pop    %ebx
80101b61:	5e                   	pop    %esi
80101b62:	5f                   	pop    %edi
80101b63:	5d                   	pop    %ebp
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b79:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b80:	00 
80101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	89 04 24             	mov    %eax,(%esp)
80101b8b:	e8 f0 27 00 00       	call   80104380 <strncmp>
}
80101b90:	c9                   	leave  
80101b91:	c3                   	ret    
80101b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 2c             	sub    $0x2c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 97 00 00 00    	jne    80101c4e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 73                	jmp    80101c38 <dirlookup+0x98>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 68                	jbe    80101c38 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bd7:	00 
80101bd8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101be0:	89 1c 24             	mov    %ebx,(%esp)
80101be3:	e8 58 fd ff ff       	call   80101940 <readi>
80101be8:	83 f8 10             	cmp    $0x10,%eax
80101beb:	75 55                	jne    80101c42 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bed:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf2:	74 d4                	je     80101bc8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c05:	00 
80101c06:	89 04 24             	mov    %eax,(%esp)
80101c09:	e8 72 27 00 00       	call   80104380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	75 b6                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c12:	8b 45 10             	mov    0x10(%ebp),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 05                	je     80101c1e <dirlookup+0x7e>
        *poff = off;
80101c19:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c1e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 c7 f5 ff ff       	call   801011f0 <iget>
    }
  }

  return 0;
}
80101c29:	83 c4 2c             	add    $0x2c,%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5f                   	pop    %edi
80101c2f:	5d                   	pop    %ebp
80101c30:	c3                   	ret    
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c3b:	31 c0                	xor    %eax,%eax
}
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
      panic("dirlookup read");
80101c42:	c7 04 24 39 6e 10 80 	movl   $0x80106e39,(%esp)
80101c49:	e8 12 e7 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c4e:	c7 04 24 27 6e 10 80 	movl   $0x80106e27,(%esp)
80101c55:	e8 06 e7 ff ff       	call   80100360 <panic>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	56                   	push   %esi
80101c67:	53                   	push   %ebx
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 51 01 00 00    	je     80101dca <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 02 1a 00 00       	call   80103680 <myproc>
80101c7e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c81:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c88:	e8 93 24 00 00       	call   80104120 <acquire>
  ip->ref++;
80101c8d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c91:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c98:	e8 73 25 00 00       	call   80104210 <release>
80101c9d:	eb 04                	jmp    80101ca3 <namex+0x43>
80101c9f:	90                   	nop
    path++;
80101ca0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ca3:	0f b6 03             	movzbl (%ebx),%eax
80101ca6:	3c 2f                	cmp    $0x2f,%al
80101ca8:	74 f6                	je     80101ca0 <namex+0x40>
  if(*path == 0)
80101caa:	84 c0                	test   %al,%al
80101cac:	0f 84 ed 00 00 00    	je     80101d9f <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cb2:	0f b6 03             	movzbl (%ebx),%eax
80101cb5:	89 da                	mov    %ebx,%edx
80101cb7:	84 c0                	test   %al,%al
80101cb9:	0f 84 b1 00 00 00    	je     80101d70 <namex+0x110>
80101cbf:	3c 2f                	cmp    $0x2f,%al
80101cc1:	75 0f                	jne    80101cd2 <namex+0x72>
80101cc3:	e9 a8 00 00 00       	jmp    80101d70 <namex+0x110>
80101cc8:	3c 2f                	cmp    $0x2f,%al
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cd0:	74 0a                	je     80101cdc <namex+0x7c>
    path++;
80101cd2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd5:	0f b6 02             	movzbl (%edx),%eax
80101cd8:	84 c0                	test   %al,%al
80101cda:	75 ec                	jne    80101cc8 <namex+0x68>
80101cdc:	89 d1                	mov    %edx,%ecx
80101cde:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce0:	83 f9 0d             	cmp    $0xd,%ecx
80101ce3:	0f 8e 8f 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ce9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ced:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cf4:	00 
80101cf5:	89 3c 24             	mov    %edi,(%esp)
80101cf8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cfb:	e8 00 26 00 00       	call   80104300 <memmove>
    path++;
80101d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d03:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d05:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d08:	75 0e                	jne    80101d18 <namex+0xb8>
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	89 34 24             	mov    %esi,(%esp)
80101d1b:	e8 70 f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d25:	0f 85 85 00 00 00    	jne    80101db0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2e:	85 d2                	test   %edx,%edx
80101d30:	74 09                	je     80101d3b <namex+0xdb>
80101d32:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d35:	0f 84 a5 00 00 00    	je     80101de0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d42:	00 
80101d43:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d47:	89 34 24             	mov    %esi,(%esp)
80101d4a:	e8 51 fe ff ff       	call   80101ba0 <dirlookup>
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 5d                	je     80101db0 <namex+0x150>
  iunlock(ip);
80101d53:	89 34 24             	mov    %esi,(%esp)
80101d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d59:	e8 12 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	89 c6                	mov    %eax,%esi
80101d6b:	e9 33 ff ff ff       	jmp    80101ca3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d70:	31 c9                	xor    %ecx,%ecx
80101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d80:	89 3c 24             	mov    %edi,(%esp)
80101d83:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d89:	e8 72 25 00 00       	call   80104300 <memmove>
    name[len] = 0;
80101d8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d94:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d98:	89 d3                	mov    %edx,%ebx
80101d9a:	e9 66 ff ff ff       	jmp    80101d05 <namex+0xa5>
  }
  if(nameiparent){
80101d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	75 4c                	jne    80101df2 <namex+0x192>
80101da6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da8:	83 c4 2c             	add    $0x2c,%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    
  iunlock(ip);
80101db0:	89 34 24             	mov    %esi,(%esp)
80101db3:	e8 b8 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 f0 f9 ff ff       	call   801017b0 <iput>
}
80101dc0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101dc3:	31 c0                	xor    %eax,%eax
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dca:	ba 01 00 00 00       	mov    $0x1,%edx
80101dcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd4:	e8 17 f4 ff ff       	call   801011f0 <iget>
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 c3 fe ff ff       	jmp    80101ca3 <namex+0x43>
      iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 88 f9 ff ff       	call   80101770 <iunlock>
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101deb:	89 f0                	mov    %esi,%eax
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
    iput(ip);
80101df2:	89 34 24             	mov    %esi,(%esp)
80101df5:	e8 b6 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101dfa:	31 c0                	xor    %eax,%eax
80101dfc:	eb aa                	jmp    80101da8 <namex+0x148>
80101dfe:	66 90                	xchg   %ax,%ax

80101e00 <dirlink>:
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 2c             	sub    $0x2c,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e16:	00 
80101e17:	89 1c 24             	mov    %ebx,(%esp)
80101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1e:	e8 7d fd ff ff       	call   80101ba0 <dirlookup>
80101e23:	85 c0                	test   %eax,%eax
80101e25:	0f 85 8b 00 00 00    	jne    80101eb6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e2e:	31 ff                	xor    %edi,%edi
80101e30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e33:	85 c0                	test   %eax,%eax
80101e35:	75 13                	jne    80101e4a <dirlink+0x4a>
80101e37:	eb 35                	jmp    80101e6e <dirlink+0x6e>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e40:	8d 57 10             	lea    0x10(%edi),%edx
80101e43:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e46:	89 d7                	mov    %edx,%edi
80101e48:	76 24                	jbe    80101e6e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e51:	00 
80101e52:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e56:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e5a:	89 1c 24             	mov    %ebx,(%esp)
80101e5d:	e8 de fa ff ff       	call   80101940 <readi>
80101e62:	83 f8 10             	cmp    $0x10,%eax
80101e65:	75 5e                	jne    80101ec5 <dirlink+0xc5>
    if(de.inum == 0)
80101e67:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6c:	75 d2                	jne    80101e40 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e71:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e78:	00 
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 68 25 00 00       	call   801043f0 <strncpy>
  de.inum = inum;
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e92:	00 
80101e93:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e97:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9b:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101e9e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea2:	e8 99 fb ff ff       	call   80101a40 <writei>
80101ea7:	83 f8 10             	cmp    $0x10,%eax
80101eaa:	75 25                	jne    80101ed1 <dirlink+0xd1>
  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	83 c4 2c             	add    $0x2c,%esp
80101eb1:	5b                   	pop    %ebx
80101eb2:	5e                   	pop    %esi
80101eb3:	5f                   	pop    %edi
80101eb4:	5d                   	pop    %ebp
80101eb5:	c3                   	ret    
    iput(ip);
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 f2 f8 ff ff       	call   801017b0 <iput>
    return -1;
80101ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec3:	eb e9                	jmp    80101eae <dirlink+0xae>
      panic("dirlink read");
80101ec5:	c7 04 24 48 6e 10 80 	movl   $0x80106e48,(%esp)
80101ecc:	e8 8f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ed1:	c7 04 24 46 74 10 80 	movl   $0x80107446,(%esp)
80101ed8:	e8 83 e4 ff ff       	call   80100360 <panic>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	89 c6                	mov    %eax,%esi
80101f26:	53                   	push   %ebx
80101f27:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	0f 84 99 00 00 00    	je     80101fcb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f32:	8b 48 08             	mov    0x8(%eax),%ecx
80101f35:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f3b:	0f 87 7e 00 00 00    	ja     80101fbf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f41:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	31 db                	xor    %ebx,%ebx
80101f52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f57:	89 d8                	mov    %ebx,%eax
80101f59:	ee                   	out    %al,(%dx)
80101f5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f64:	ee                   	out    %al,(%dx)
80101f65:	0f b6 c1             	movzbl %cl,%eax
80101f68:	b2 f3                	mov    $0xf3,%dl
80101f6a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f6b:	89 c8                	mov    %ecx,%eax
80101f6d:	b2 f4                	mov    $0xf4,%dl
80101f6f:	c1 f8 08             	sar    $0x8,%eax
80101f72:	ee                   	out    %al,(%dx)
80101f73:	b2 f5                	mov    $0xf5,%dl
80101f75:	89 d8                	mov    %ebx,%eax
80101f77:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f78:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f7c:	b2 f6                	mov    $0xf6,%dl
80101f7e:	83 e0 01             	and    $0x1,%eax
80101f81:	c1 e0 04             	shl    $0x4,%eax
80101f84:	83 c8 e0             	or     $0xffffffe0,%eax
80101f87:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f88:	f6 06 04             	testb  $0x4,(%esi)
80101f8b:	75 13                	jne    80101fa0 <idestart+0x80>
80101f8d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f92:	b8 20 00 00 00       	mov    $0x20,%eax
80101f97:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
80101f9f:	90                   	nop
80101fa0:	b2 f7                	mov    $0xf7,%dl
80101fa2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fa8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fad:	83 c6 5c             	add    $0x5c,%esi
80101fb0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fb5:	fc                   	cld    
80101fb6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
    panic("incorrect blockno");
80101fbf:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80101fc6:	e8 95 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101fcb:	c7 04 24 ab 6e 10 80 	movl   $0x80106eab,(%esp)
80101fd2:	e8 89 e3 ff ff       	call   80100360 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80101fe6:	c7 44 24 04 c6 6e 10 	movl   $0x80106ec6,0x4(%esp)
80101fed:	80 
80101fee:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101ff5:	e8 36 20 00 00       	call   80104030 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101ffa:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fff:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102006:	83 e8 01             	sub    $0x1,%eax
80102009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010200d:	e8 7e 02 00 00       	call   80102290 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102012:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102017:	90                   	nop
80102018:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102019:	83 e0 c0             	and    $0xffffffc0,%eax
8010201c:	3c 40                	cmp    $0x40,%al
8010201e:	75 f8                	jne    80102018 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102020:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102025:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010202a:	ee                   	out    %al,(%dx)
8010202b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102030:	b2 f7                	mov    $0xf7,%dl
80102032:	eb 09                	jmp    8010203d <ideinit+0x5d>
80102034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102038:	83 e9 01             	sub    $0x1,%ecx
8010203b:	74 0f                	je     8010204c <ideinit+0x6c>
8010203d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010203e:	84 c0                	test   %al,%al
80102040:	74 f6                	je     80102038 <ideinit+0x58>
      havedisk1 = 1;
80102042:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102049:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010204c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102051:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102056:	ee                   	out    %al,(%dx)
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102069:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102070:	e8 ab 20 00 00       	call   80104120 <acquire>

  if((b = idequeue) == 0){
80102075:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010207b:	85 db                	test   %ebx,%ebx
8010207d:	74 30                	je     801020af <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010207f:	8b 43 58             	mov    0x58(%ebx),%eax
80102082:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102087:	8b 33                	mov    (%ebx),%esi
80102089:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010208f:	74 37                	je     801020c8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102091:	83 e6 fb             	and    $0xfffffffb,%esi
80102094:	83 ce 02             	or     $0x2,%esi
80102097:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102099:	89 1c 24             	mov    %ebx,(%esp)
8010209c:	e8 cf 1c 00 00       	call   80103d70 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020a1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020a6:	85 c0                	test   %eax,%eax
801020a8:	74 05                	je     801020af <ideintr+0x4f>
    idestart(idequeue);
801020aa:	e8 71 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
801020af:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020b6:	e8 55 21 00 00       	call   80104210 <release>

  release(&idelock);
}
801020bb:	83 c4 1c             	add    $0x1c,%esp
801020be:	5b                   	pop    %ebx
801020bf:	5e                   	pop    %esi
801020c0:	5f                   	pop    %edi
801020c1:	5d                   	pop    %ebp
801020c2:	c3                   	ret    
801020c3:	90                   	nop
801020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020cd:	8d 76 00             	lea    0x0(%esi),%esi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c1                	mov    %eax,%ecx
801020d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020d6:	80 f9 40             	cmp    $0x40,%cl
801020d9:	75 f5                	jne    801020d0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020db:	a8 21                	test   $0x21,%al
801020dd:	75 b2                	jne    80102091 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ec:	fc                   	cld    
801020ed:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ef:	8b 33                	mov    (%ebx),%esi
801020f1:	eb 9e                	jmp    80102091 <ideintr+0x31>
801020f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102100 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 14             	sub    $0x14,%esp
80102107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010210a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010210d:	89 04 24             	mov    %eax,(%esp)
80102110:	e8 eb 1e 00 00       	call   80104000 <holdingsleep>
80102115:	85 c0                	test   %eax,%eax
80102117:	0f 84 9e 00 00 00    	je     801021bb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010211d:	8b 03                	mov    (%ebx),%eax
8010211f:	83 e0 06             	and    $0x6,%eax
80102122:	83 f8 02             	cmp    $0x2,%eax
80102125:	0f 84 a8 00 00 00    	je     801021d3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010212b:	8b 53 04             	mov    0x4(%ebx),%edx
8010212e:	85 d2                	test   %edx,%edx
80102130:	74 0d                	je     8010213f <iderw+0x3f>
80102132:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102137:	85 c0                	test   %eax,%eax
80102139:	0f 84 88 00 00 00    	je     801021c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010213f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102146:	e8 d5 1f 00 00       	call   80104120 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102150:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102157:	85 c0                	test   %eax,%eax
80102159:	75 07                	jne    80102162 <iderw+0x62>
8010215b:	eb 4e                	jmp    801021ab <iderw+0xab>
8010215d:	8d 76 00             	lea    0x0(%esi),%esi
80102160:	89 d0                	mov    %edx,%eax
80102162:	8b 50 58             	mov    0x58(%eax),%edx
80102165:	85 d2                	test   %edx,%edx
80102167:	75 f7                	jne    80102160 <iderw+0x60>
80102169:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010216c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010216e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102174:	74 3c                	je     801021b2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102176:	8b 03                	mov    (%ebx),%eax
80102178:	83 e0 06             	and    $0x6,%eax
8010217b:	83 f8 02             	cmp    $0x2,%eax
8010217e:	74 1a                	je     8010219a <iderw+0x9a>
    sleep(b, &idelock);
80102180:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102187:	80 
80102188:	89 1c 24             	mov    %ebx,(%esp)
8010218b:	e8 50 1a 00 00       	call   80103be0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102190:	8b 13                	mov    (%ebx),%edx
80102192:	83 e2 06             	and    $0x6,%edx
80102195:	83 fa 02             	cmp    $0x2,%edx
80102198:	75 e6                	jne    80102180 <iderw+0x80>
  }


  release(&idelock);
8010219a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a1:	83 c4 14             	add    $0x14,%esp
801021a4:	5b                   	pop    %ebx
801021a5:	5d                   	pop    %ebp
  release(&idelock);
801021a6:	e9 65 20 00 00       	jmp    80104210 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021b0:	eb ba                	jmp    8010216c <iderw+0x6c>
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 67 fd ff ff       	call   80101f20 <idestart>
801021b9:	eb bb                	jmp    80102176 <iderw+0x76>
    panic("iderw: buf not locked");
801021bb:	c7 04 24 ca 6e 10 80 	movl   $0x80106eca,(%esp)
801021c2:	e8 99 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021c7:	c7 04 24 f5 6e 10 80 	movl   $0x80106ef5,(%esp)
801021ce:	e8 8d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021d3:	c7 04 24 e0 6e 10 80 	movl   $0x80106ee0,(%esp)
801021da:	e8 81 e1 ff ff       	call   80100360 <panic>
801021df:	90                   	nop

801021e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	56                   	push   %esi
801021e4:	53                   	push   %ebx
801021e5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021e8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021ef:	00 c0 fe 
  ioapic->reg = reg;
801021f2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f9:	00 00 00 
  return ioapic->data;
801021fc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102202:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102205:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010220b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102211:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102218:	c1 e8 10             	shr    $0x10,%eax
8010221b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010221e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102221:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102224:	39 c2                	cmp    %eax,%edx
80102226:	74 12                	je     8010223a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102228:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
8010222f:	e8 1c e4 ff ff       	call   80100650 <cprintf>
80102234:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010223a:	ba 10 00 00 00       	mov    $0x10,%edx
8010223f:	31 c0                	xor    %eax,%eax
80102241:	eb 07                	jmp    8010224a <ioapicinit+0x6a>
80102243:	90                   	nop
80102244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102248:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010224a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010224c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102252:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102255:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010225b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010225e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102261:	8d 4a 01             	lea    0x1(%edx),%ecx
80102264:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102267:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102269:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010226f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102271:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102278:	7d ce                	jge    80102248 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227a:	83 c4 10             	add    $0x10,%esp
8010227d:	5b                   	pop    %ebx
8010227e:	5e                   	pop    %esi
8010227f:	5d                   	pop    %ebp
80102280:	c3                   	ret    
80102281:	eb 0d                	jmp    80102290 <ioapicenable>
80102283:	90                   	nop
80102284:	90                   	nop
80102285:	90                   	nop
80102286:	90                   	nop
80102287:	90                   	nop
80102288:	90                   	nop
80102289:	90                   	nop
8010228a:	90                   	nop
8010228b:	90                   	nop
8010228c:	90                   	nop
8010228d:	90                   	nop
8010228e:	90                   	nop
8010228f:	90                   	nop

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 55 08             	mov    0x8(%ebp),%edx
80102296:	53                   	push   %ebx
80102297:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010229a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010229d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022a1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022a7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022aa:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ac:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022b5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022b8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ba:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022c0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022c3:	5b                   	pop    %ebx
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	66 90                	xchg   %ax,%ax
801022c8:	66 90                	xchg   %ax,%ax
801022ca:	66 90                	xchg   %ax,%ax
801022cc:	66 90                	xchg   %ax,%ax
801022ce:	66 90                	xchg   %ax,%ax

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 14             	sub    $0x14,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 7c                	jne    8010235e <kfree+0x8e>
801022e2:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
801022e8:	72 74                	jb     8010235e <kfree+0x8e>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 67                	ja     8010235e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801022fe:	00 
801022ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102306:	00 
80102307:	89 1c 24             	mov    %ebx,(%esp)
8010230a:	e8 51 1f 00 00       	call   80104260 <memset>

  if(kmem.use_lock)
8010230f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102315:	85 d2                	test   %edx,%edx
80102317:	75 37                	jne    80102350 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102319:	a1 78 26 11 80       	mov    0x80112678,%eax
8010231e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102320:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102325:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010232b:	85 c0                	test   %eax,%eax
8010232d:	75 09                	jne    80102338 <kfree+0x68>
    release(&kmem.lock);
}
8010232f:	83 c4 14             	add    $0x14,%esp
80102332:	5b                   	pop    %ebx
80102333:	5d                   	pop    %ebp
80102334:	c3                   	ret    
80102335:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102338:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
    release(&kmem.lock);
80102344:	e9 c7 1e 00 00       	jmp    80104210 <release>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102350:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102357:	e8 c4 1d 00 00       	call   80104120 <acquire>
8010235c:	eb bb                	jmp    80102319 <kfree+0x49>
    panic("kfree");
8010235e:	c7 04 24 46 6f 10 80 	movl   $0x80106f46,(%esp)
80102365:	e8 f6 df ff ff       	call   80100360 <panic>
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102370 <freerange>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
80102375:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102378:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010237b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010237e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102384:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102390:	39 de                	cmp    %ebx,%esi
80102392:	73 08                	jae    8010239c <freerange+0x2c>
80102394:	eb 18                	jmp    801023ae <freerange+0x3e>
80102396:	66 90                	xchg   %ax,%ax
80102398:	89 da                	mov    %ebx,%edx
8010239a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010239c:	89 14 24             	mov    %edx,(%esp)
8010239f:	e8 2c ff ff ff       	call   801022d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023aa:	39 f0                	cmp    %esi,%eax
801023ac:	76 ea                	jbe    80102398 <freerange+0x28>
}
801023ae:	83 c4 10             	add    $0x10,%esp
801023b1:	5b                   	pop    %ebx
801023b2:	5e                   	pop    %esi
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
801023b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023c0 <kinit1>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	83 ec 10             	sub    $0x10,%esp
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023cb:	c7 44 24 04 4c 6f 10 	movl   $0x80106f4c,0x4(%esp)
801023d2:	80 
801023d3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023da:	e8 51 1c 00 00       	call   80104030 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023df:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801023e2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023e9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023ec:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023f2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023fe:	39 de                	cmp    %ebx,%esi
80102400:	73 0a                	jae    8010240c <kinit1+0x4c>
80102402:	eb 1a                	jmp    8010241e <kinit1+0x5e>
80102404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102408:	89 da                	mov    %ebx,%edx
8010240a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010240c:	89 14 24             	mov    %edx,(%esp)
8010240f:	e8 bc fe ff ff       	call   801022d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102414:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010241a:	39 c6                	cmp    %eax,%esi
8010241c:	73 ea                	jae    80102408 <kinit1+0x48>
}
8010241e:	83 c4 10             	add    $0x10,%esp
80102421:	5b                   	pop    %ebx
80102422:	5e                   	pop    %esi
80102423:	5d                   	pop    %ebp
80102424:	c3                   	ret    
80102425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102438:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010243b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010243e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102444:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102450:	39 de                	cmp    %ebx,%esi
80102452:	73 08                	jae    8010245c <kinit2+0x2c>
80102454:	eb 18                	jmp    8010246e <kinit2+0x3e>
80102456:	66 90                	xchg   %ax,%ax
80102458:	89 da                	mov    %ebx,%edx
8010245a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010245c:	89 14 24             	mov    %edx,(%esp)
8010245f:	e8 6c fe ff ff       	call   801022d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102464:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010246a:	39 c6                	cmp    %eax,%esi
8010246c:	73 ea                	jae    80102458 <kinit2+0x28>
  kmem.use_lock = 1;
8010246e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102475:	00 00 00 
}
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	5b                   	pop    %ebx
8010247c:	5e                   	pop    %esi
8010247d:	5d                   	pop    %ebp
8010247e:	c3                   	ret    
8010247f:	90                   	nop

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 74 26 11 80       	mov    0x80112674,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 08                	je     801024a2 <kalloc+0x22>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 0c                	je     801024b2 <kalloc+0x32>
    release(&kmem.lock);
801024a6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024ad:	e8 5e 1d 00 00       	call   80104210 <release>
  return (char*)r;
}
801024b2:	83 c4 14             	add    $0x14,%esp
801024b5:	89 d8                	mov    %ebx,%eax
801024b7:	5b                   	pop    %ebx
801024b8:	5d                   	pop    %ebp
801024b9:	c3                   	ret    
801024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024c0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024c7:	e8 54 1c 00 00       	call   80104120 <acquire>
801024cc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024d1:	eb bd                	jmp    80102490 <kalloc+0x10>
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e0:	ba 64 00 00 00       	mov    $0x64,%edx
801024e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024e6:	a8 01                	test   $0x1,%al
801024e8:	0f 84 ba 00 00 00    	je     801025a8 <kbdgetc+0xc8>
801024ee:	b2 60                	mov    $0x60,%dl
801024f0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024f1:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801024f4:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
801024fa:	0f 84 88 00 00 00    	je     80102588 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102500:	84 c0                	test   %al,%al
80102502:	79 2c                	jns    80102530 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102504:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010250a:	f6 c2 40             	test   $0x40,%dl
8010250d:	75 05                	jne    80102514 <kbdgetc+0x34>
8010250f:	89 c1                	mov    %eax,%ecx
80102511:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102514:	0f b6 81 80 70 10 80 	movzbl -0x7fef8f80(%ecx),%eax
8010251b:	83 c8 40             	or     $0x40,%eax
8010251e:	0f b6 c0             	movzbl %al,%eax
80102521:	f7 d0                	not    %eax
80102523:	21 d0                	and    %edx,%eax
80102525:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010252a:	31 c0                	xor    %eax,%eax
8010252c:	c3                   	ret    
8010252d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010253a:	f6 c3 40             	test   $0x40,%bl
8010253d:	74 09                	je     80102548 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010253f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102542:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102545:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102548:	0f b6 91 80 70 10 80 	movzbl -0x7fef8f80(%ecx),%edx
  shift ^= togglecode[data];
8010254f:	0f b6 81 80 6f 10 80 	movzbl -0x7fef9080(%ecx),%eax
  shift |= shiftcode[data];
80102556:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102558:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010255a:	89 d0                	mov    %edx,%eax
8010255c:	83 e0 03             	and    $0x3,%eax
8010255f:	8b 04 85 60 6f 10 80 	mov    -0x7fef90a0(,%eax,4),%eax
  shift ^= togglecode[data];
80102566:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010256c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102573:	74 0b                	je     80102580 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102575:	8d 50 9f             	lea    -0x61(%eax),%edx
80102578:	83 fa 19             	cmp    $0x19,%edx
8010257b:	77 1b                	ja     80102598 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010257d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102580:	5b                   	pop    %ebx
80102581:	5d                   	pop    %ebp
80102582:	c3                   	ret    
80102583:	90                   	nop
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102588:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010258f:	31 c0                	xor    %eax,%eax
80102591:	c3                   	ret    
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102598:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010259b:	8d 50 20             	lea    0x20(%eax),%edx
8010259e:	83 f9 19             	cmp    $0x19,%ecx
801025a1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025a4:	eb da                	jmp    80102580 <kbdgetc+0xa0>
801025a6:	66 90                	xchg   %ax,%ax
    return -1;
801025a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <kbdintr>:

void
kbdintr(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025b6:	c7 04 24 e0 24 10 80 	movl   $0x801024e0,(%esp)
801025bd:	e8 ee e1 ff ff       	call   801007b0 <consoleintr>
}
801025c2:	c9                   	leave  
801025c3:	c3                   	ret    
801025c4:	66 90                	xchg   %ax,%ax
801025c6:	66 90                	xchg   %ax,%ax
801025c8:	66 90                	xchg   %ax,%ax
801025ca:	66 90                	xchg   %ax,%ax
801025cc:	66 90                	xchg   %ax,%ax
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025d0:	55                   	push   %ebp
801025d1:	89 c1                	mov    %eax,%ecx
801025d3:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d5:	ba 70 00 00 00       	mov    $0x70,%edx
801025da:	53                   	push   %ebx
801025db:	31 c0                	xor    %eax,%eax
801025dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025de:	bb 71 00 00 00       	mov    $0x71,%ebx
801025e3:	89 da                	mov    %ebx,%edx
801025e5:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801025e6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e9:	b2 70                	mov    $0x70,%dl
801025eb:	89 01                	mov    %eax,(%ecx)
801025ed:	b8 02 00 00 00       	mov    $0x2,%eax
801025f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
801025f6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 41 04             	mov    %eax,0x4(%ecx)
801025fe:	b8 04 00 00 00       	mov    $0x4,%eax
80102603:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102604:	89 da                	mov    %ebx,%edx
80102606:	ec                   	in     (%dx),%al
80102607:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010260a:	b2 70                	mov    $0x70,%dl
8010260c:	89 41 08             	mov    %eax,0x8(%ecx)
8010260f:	b8 07 00 00 00       	mov    $0x7,%eax
80102614:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102615:	89 da                	mov    %ebx,%edx
80102617:	ec                   	in     (%dx),%al
80102618:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261b:	b2 70                	mov    $0x70,%dl
8010261d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102620:	b8 08 00 00 00       	mov    $0x8,%eax
80102625:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102626:	89 da                	mov    %ebx,%edx
80102628:	ec                   	in     (%dx),%al
80102629:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262c:	b2 70                	mov    $0x70,%dl
8010262e:	89 41 10             	mov    %eax,0x10(%ecx)
80102631:	b8 09 00 00 00       	mov    $0x9,%eax
80102636:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102637:	89 da                	mov    %ebx,%edx
80102639:	ec                   	in     (%dx),%al
8010263a:	0f b6 d8             	movzbl %al,%ebx
8010263d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102640:	5b                   	pop    %ebx
80102641:	5d                   	pop    %ebp
80102642:	c3                   	ret    
80102643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <lapicinit>:
  if(!lapic)
80102650:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102658:	85 c0                	test   %eax,%eax
8010265a:	0f 84 c0 00 00 00    	je     80102720 <lapicinit+0xd0>
  lapic[index] = value;
80102660:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102667:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102681:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102687:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010268e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102694:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010269b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ab:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ae:	8b 50 30             	mov    0x30(%eax),%edx
801026b1:	c1 ea 10             	shr    $0x10,%edx
801026b4:	80 fa 03             	cmp    $0x3,%dl
801026b7:	77 6f                	ja     80102728 <lapicinit+0xd8>
  lapic[index] = value;
801026b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102701:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
80102707:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102708:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010270e:	80 e6 10             	and    $0x10,%dh
80102711:	75 f5                	jne    80102708 <lapicinit+0xb8>
  lapic[index] = value;
80102713:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010271a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102720:	5d                   	pop    %ebp
80102721:	c3                   	ret    
80102722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102728:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010272f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102732:	8b 50 20             	mov    0x20(%eax),%edx
80102735:	eb 82                	jmp    801026b9 <lapicinit+0x69>
80102737:	89 f6                	mov    %esi,%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:
  if (!lapic)
80102740:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102745:	55                   	push   %ebp
80102746:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102748:	85 c0                	test   %eax,%eax
8010274a:	74 0c                	je     80102758 <lapicid+0x18>
  return lapic[ID] >> 24;
8010274c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010274f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102750:	c1 e8 18             	shr    $0x18,%eax
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102758:	31 c0                	xor    %eax,%eax
}
8010275a:	5d                   	pop    %ebp
8010275b:	c3                   	ret    
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <lapiceoi>:
  if(lapic)
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	ba 70 00 00 00       	mov    $0x70,%edx
80102796:	89 e5                	mov    %esp,%ebp
80102798:	b8 0f 00 00 00       	mov    $0xf,%eax
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	b2 71                	mov    $0x71,%dl
801027ac:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027ad:	31 c0                	xor    %eax,%eax
801027af:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027b5:	89 d8                	mov    %ebx,%eax
801027b7:	c1 e8 04             	shr    $0x4,%eax
801027ba:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027c5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027cb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027db:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ee:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f4:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f7:	89 da                	mov    %ebx,%edx
801027f9:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
801027fc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102802:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102805:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010280e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 40 20             	mov    0x20(%eax),%eax
}
80102817:	5b                   	pop    %ebx
80102818:	5d                   	pop    %ebp
80102819:	c3                   	ret    
8010281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102820 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	89 e5                	mov    %esp,%ebp
80102828:	b8 0b 00 00 00       	mov    $0xb,%eax
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	b2 71                	mov    $0x71,%dl
80102836:	ec                   	in     (%dx),%al
80102837:	88 45 b7             	mov    %al,-0x49(%ebp)
8010283a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010283d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102841:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010284d:	89 d8                	mov    %ebx,%eax
8010284f:	e8 7c fd ff ff       	call   801025d0 <fill_rtcdate>
80102854:	b8 0a 00 00 00       	mov    $0xa,%eax
80102859:	89 f2                	mov    %esi,%edx
8010285b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285c:	ba 71 00 00 00       	mov    $0x71,%edx
80102861:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102862:	84 c0                	test   %al,%al
80102864:	78 e7                	js     8010284d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102866:	89 f8                	mov    %edi,%eax
80102868:	e8 63 fd ff ff       	call   801025d0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010286d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102874:	00 
80102875:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102879:	89 1c 24             	mov    %ebx,(%esp)
8010287c:	e8 2f 1a 00 00       	call   801042b0 <memcmp>
80102881:	85 c0                	test   %eax,%eax
80102883:	75 c3                	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102885:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102889:	75 78                	jne    80102903 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010288b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010288e:	89 c2                	mov    %eax,%edx
80102890:	83 e0 0f             	and    $0xf,%eax
80102893:	c1 ea 04             	shr    $0x4,%edx
80102896:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102899:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010289c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010289f:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028a2:	89 c2                	mov    %eax,%edx
801028a4:	83 e0 0f             	and    $0xf,%eax
801028a7:	c1 ea 04             	shr    $0x4,%edx
801028aa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ad:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028b6:	89 c2                	mov    %eax,%edx
801028b8:	83 e0 0f             	and    $0xf,%eax
801028bb:	c1 ea 04             	shr    $0x4,%edx
801028be:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ca:	89 c2                	mov    %eax,%edx
801028cc:	83 e0 0f             	and    $0xf,%eax
801028cf:	c1 ea 04             	shr    $0x4,%edx
801028d2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028db:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028de:	89 c2                	mov    %eax,%edx
801028e0:	83 e0 0f             	and    $0xf,%eax
801028e3:	c1 ea 04             	shr    $0x4,%edx
801028e6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
801028f2:	89 c2                	mov    %eax,%edx
801028f4:	83 e0 0f             	and    $0xf,%eax
801028f7:	c1 ea 04             	shr    $0x4,%edx
801028fa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102900:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102903:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102906:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102909:	89 01                	mov    %eax,(%ecx)
8010290b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010290e:	89 41 04             	mov    %eax,0x4(%ecx)
80102911:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102914:	89 41 08             	mov    %eax,0x8(%ecx)
80102917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010291a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010291d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102920:	89 41 10             	mov    %eax,0x10(%ecx)
80102923:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102926:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102929:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102930:	83 c4 4c             	add    $0x4c,%esp
80102933:	5b                   	pop    %ebx
80102934:	5e                   	pop    %esi
80102935:	5f                   	pop    %edi
80102936:	5d                   	pop    %ebp
80102937:	c3                   	ret    
80102938:	66 90                	xchg   %ax,%ax
8010293a:	66 90                	xchg   %ax,%ax
8010293c:	66 90                	xchg   %ax,%ax
8010293e:	66 90                	xchg   %ax,%ax

80102940 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	57                   	push   %edi
80102944:	56                   	push   %esi
80102945:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102946:	31 db                	xor    %ebx,%ebx
{
80102948:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010294b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102950:	85 c0                	test   %eax,%eax
80102952:	7e 78                	jle    801029cc <install_trans+0x8c>
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102958:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010295d:	01 d8                	add    %ebx,%eax
8010295f:	83 c0 01             	add    $0x1,%eax
80102962:	89 44 24 04          	mov    %eax,0x4(%esp)
80102966:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010296b:	89 04 24             	mov    %eax,(%esp)
8010296e:	e8 5d d7 ff ff       	call   801000d0 <bread>
80102973:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102975:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
8010297c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010297f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102983:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102988:	89 04 24             	mov    %eax,(%esp)
8010298b:	e8 40 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102990:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102997:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102998:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010299a:	8d 47 5c             	lea    0x5c(%edi),%eax
8010299d:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029a4:	89 04 24             	mov    %eax,(%esp)
801029a7:	e8 54 19 00 00       	call   80104300 <memmove>
    bwrite(dbuf);  // write dst to disk
801029ac:	89 34 24             	mov    %esi,(%esp)
801029af:	e8 ec d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029b4:	89 3c 24             	mov    %edi,(%esp)
801029b7:	e8 24 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029bc:	89 34 24             	mov    %esi,(%esp)
801029bf:	e8 1c d8 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029c4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029ca:	7f 8c                	jg     80102958 <install_trans+0x18>
  }
}
801029cc:	83 c4 1c             	add    $0x1c,%esp
801029cf:	5b                   	pop    %ebx
801029d0:	5e                   	pop    %esi
801029d1:	5f                   	pop    %edi
801029d2:	5d                   	pop    %ebp
801029d3:	c3                   	ret    
801029d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029e0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	57                   	push   %edi
801029e4:	56                   	push   %esi
801029e5:	53                   	push   %ebx
801029e6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029e9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029f7:	89 04 24             	mov    %eax,(%esp)
801029fa:	e8 d1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801029ff:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a05:	31 d2                	xor    %edx,%edx
80102a07:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a09:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a0b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a0e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a11:	7e 17                	jle    80102a2a <write_head+0x4a>
80102a13:	90                   	nop
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a18:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a1f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a23:	83 c2 01             	add    $0x1,%edx
80102a26:	39 da                	cmp    %ebx,%edx
80102a28:	75 ee                	jne    80102a18 <write_head+0x38>
  }
  bwrite(buf);
80102a2a:	89 3c 24             	mov    %edi,(%esp)
80102a2d:	e8 6e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a32:	89 3c 24             	mov    %edi,(%esp)
80102a35:	e8 a6 d7 ff ff       	call   801001e0 <brelse>
}
80102a3a:	83 c4 1c             	add    $0x1c,%esp
80102a3d:	5b                   	pop    %ebx
80102a3e:	5e                   	pop    %esi
80102a3f:	5f                   	pop    %edi
80102a40:	5d                   	pop    %ebp
80102a41:	c3                   	ret    
80102a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <initlog>:
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	56                   	push   %esi
80102a54:	53                   	push   %ebx
80102a55:	83 ec 30             	sub    $0x30,%esp
80102a58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a5b:	c7 44 24 04 80 71 10 	movl   $0x80107180,0x4(%esp)
80102a62:	80 
80102a63:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a6a:	e8 c1 15 00 00       	call   80104030 <initlock>
  readsb(dev, &sb);
80102a6f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a72:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a76:	89 1c 24             	mov    %ebx,(%esp)
80102a79:	e8 f2 e8 ff ff       	call   80101370 <readsb>
  log.start = sb.logstart;
80102a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102a84:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102a87:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102a91:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102a97:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102a9c:	e8 2f d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102aa1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102aa3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102aa6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102aa9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102aab:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	7e 17                	jle    80102aca <initlog+0x7a>
80102ab3:	90                   	nop
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ab8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102abc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ac3:	83 c2 01             	add    $0x1,%edx
80102ac6:	39 da                	cmp    %ebx,%edx
80102ac8:	75 ee                	jne    80102ab8 <initlog+0x68>
  brelse(buf);
80102aca:	89 04 24             	mov    %eax,(%esp)
80102acd:	e8 0e d7 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ad2:	e8 69 fe ff ff       	call   80102940 <install_trans>
  log.lh.n = 0;
80102ad7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ade:	00 00 00 
  write_head(); // clear the log
80102ae1:	e8 fa fe ff ff       	call   801029e0 <write_head>
}
80102ae6:	83 c4 30             	add    $0x30,%esp
80102ae9:	5b                   	pop    %ebx
80102aea:	5e                   	pop    %esi
80102aeb:	5d                   	pop    %ebp
80102aec:	c3                   	ret    
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102af6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102afd:	e8 1e 16 00 00       	call   80104120 <acquire>
80102b02:	eb 18                	jmp    80102b1c <begin_op+0x2c>
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b08:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b0f:	80 
80102b10:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b17:	e8 c4 10 00 00       	call   80103be0 <sleep>
    if(log.committing){
80102b1c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b21:	85 c0                	test   %eax,%eax
80102b23:	75 e3                	jne    80102b08 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b25:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b2a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b30:	83 c0 01             	add    $0x1,%eax
80102b33:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b36:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b39:	83 fa 1e             	cmp    $0x1e,%edx
80102b3c:	7f ca                	jg     80102b08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b3e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b45:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b4a:	e8 c1 16 00 00       	call   80104210 <release>
      break;
    }
  }
}
80102b4f:	c9                   	leave  
80102b50:	c3                   	ret    
80102b51:	eb 0d                	jmp    80102b60 <end_op>
80102b53:	90                   	nop
80102b54:	90                   	nop
80102b55:	90                   	nop
80102b56:	90                   	nop
80102b57:	90                   	nop
80102b58:	90                   	nop
80102b59:	90                   	nop
80102b5a:	90                   	nop
80102b5b:	90                   	nop
80102b5c:	90                   	nop
80102b5d:	90                   	nop
80102b5e:	90                   	nop
80102b5f:	90                   	nop

80102b60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	57                   	push   %edi
80102b64:	56                   	push   %esi
80102b65:	53                   	push   %ebx
80102b66:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b69:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b70:	e8 ab 15 00 00       	call   80104120 <acquire>
  log.outstanding -= 1;
80102b75:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b7a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102b80:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b83:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102b85:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b8a:	0f 85 f3 00 00 00    	jne    80102c83 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102b90:	85 c0                	test   %eax,%eax
80102b92:	0f 85 cb 00 00 00    	jne    80102c63 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b98:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b9f:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102ba1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102ba8:	00 00 00 
  release(&log.lock);
80102bab:	e8 60 16 00 00       	call   80104210 <release>
  if (log.lh.n > 0) {
80102bb0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	0f 8e 90 00 00 00    	jle    80102c4d <end_op+0xed>
80102bbd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bc5:	01 d8                	add    %ebx,%eax
80102bc7:	83 c0 01             	add    $0x1,%eax
80102bca:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bce:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bd3:	89 04 24             	mov    %eax,(%esp)
80102bd6:	e8 f5 d4 ff ff       	call   801000d0 <bread>
80102bdb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bdd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102be4:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102be7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102beb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bf0:	89 04 24             	mov    %eax,(%esp)
80102bf3:	e8 d8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102bf8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102bff:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c00:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c02:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c05:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c09:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c0c:	89 04 24             	mov    %eax,(%esp)
80102c0f:	e8 ec 16 00 00       	call   80104300 <memmove>
    bwrite(to);  // write the log
80102c14:	89 34 24             	mov    %esi,(%esp)
80102c17:	e8 84 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c1c:	89 3c 24             	mov    %edi,(%esp)
80102c1f:	e8 bc d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c24:	89 34 24             	mov    %esi,(%esp)
80102c27:	e8 b4 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c32:	7c 8c                	jl     80102bc0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c34:	e8 a7 fd ff ff       	call   801029e0 <write_head>
    install_trans(); // Now install writes to home locations
80102c39:	e8 02 fd ff ff       	call   80102940 <install_trans>
    log.lh.n = 0;
80102c3e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c45:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c48:	e8 93 fd ff ff       	call   801029e0 <write_head>
    acquire(&log.lock);
80102c4d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c54:	e8 c7 14 00 00       	call   80104120 <acquire>
    log.committing = 0;
80102c59:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c60:	00 00 00 
    wakeup(&log);
80102c63:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c6a:	e8 01 11 00 00       	call   80103d70 <wakeup>
    release(&log.lock);
80102c6f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c76:	e8 95 15 00 00       	call   80104210 <release>
}
80102c7b:	83 c4 1c             	add    $0x1c,%esp
80102c7e:	5b                   	pop    %ebx
80102c7f:	5e                   	pop    %esi
80102c80:	5f                   	pop    %edi
80102c81:	5d                   	pop    %ebp
80102c82:	c3                   	ret    
    panic("log.committing");
80102c83:	c7 04 24 84 71 10 80 	movl   $0x80107184,(%esp)
80102c8a:	e8 d1 d6 ff ff       	call   80100360 <panic>
80102c8f:	90                   	nop

80102c90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c97:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102c9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c9f:	83 f8 1d             	cmp    $0x1d,%eax
80102ca2:	0f 8f 98 00 00 00    	jg     80102d40 <log_write+0xb0>
80102ca8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cae:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cb1:	39 d0                	cmp    %edx,%eax
80102cb3:	0f 8d 87 00 00 00    	jge    80102d40 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cb9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cbe:	85 c0                	test   %eax,%eax
80102cc0:	0f 8e 86 00 00 00    	jle    80102d4c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cc6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ccd:	e8 4e 14 00 00       	call   80104120 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cd2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cd8:	83 fa 00             	cmp    $0x0,%edx
80102cdb:	7e 54                	jle    80102d31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cdd:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ce0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ce2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102ce8:	75 0f                	jne    80102cf9 <log_write+0x69>
80102cea:	eb 3c                	jmp    80102d28 <log_write+0x98>
80102cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cf0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102cf7:	74 2f                	je     80102d28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102cf9:	83 c0 01             	add    $0x1,%eax
80102cfc:	39 d0                	cmp    %edx,%eax
80102cfe:	75 f0                	jne    80102cf0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d00:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d07:	83 c2 01             	add    $0x1,%edx
80102d0a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d13:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d1a:	83 c4 14             	add    $0x14,%esp
80102d1d:	5b                   	pop    %ebx
80102d1e:	5d                   	pop    %ebp
  release(&log.lock);
80102d1f:	e9 ec 14 00 00       	jmp    80104210 <release>
80102d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d28:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d2f:	eb df                	jmp    80102d10 <log_write+0x80>
80102d31:	8b 43 08             	mov    0x8(%ebx),%eax
80102d34:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d39:	75 d5                	jne    80102d10 <log_write+0x80>
80102d3b:	eb ca                	jmp    80102d07 <log_write+0x77>
80102d3d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d40:	c7 04 24 93 71 10 80 	movl   $0x80107193,(%esp)
80102d47:	e8 14 d6 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d4c:	c7 04 24 a9 71 10 80 	movl   $0x801071a9,(%esp)
80102d53:	e8 08 d6 ff ff       	call   80100360 <panic>
80102d58:	66 90                	xchg   %ax,%ax
80102d5a:	66 90                	xchg   %ax,%ax
80102d5c:	66 90                	xchg   %ax,%ax
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d67:	e8 f4 08 00 00       	call   80103660 <cpuid>
80102d6c:	89 c3                	mov    %eax,%ebx
80102d6e:	e8 ed 08 00 00       	call   80103660 <cpuid>
80102d73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d77:	c7 04 24 c4 71 10 80 	movl   $0x801071c4,(%esp)
80102d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d82:	e8 c9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d87:	e8 54 27 00 00       	call   801054e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d8c:	e8 4f 08 00 00       	call   801035e0 <mycpu>
80102d91:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102d93:	b8 01 00 00 00       	mov    $0x1,%eax
80102d98:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d9f:	e8 9c 0b 00 00       	call   80103940 <scheduler>
80102da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102db0 <mpenter>:
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102db6:	e8 e5 37 00 00       	call   801065a0 <switchkvm>
  seginit();
80102dbb:	e8 a0 36 00 00       	call   80106460 <seginit>
  lapicinit();
80102dc0:	e8 8b f8 ff ff       	call   80102650 <lapicinit>
  mpmain();
80102dc5:	e8 96 ff ff ff       	call   80102d60 <mpmain>
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <main>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102dd4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102dd9:	83 e4 f0             	and    $0xfffffff0,%esp
80102ddc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ddf:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102de6:	80 
80102de7:	c7 04 24 f4 57 11 80 	movl   $0x801157f4,(%esp)
80102dee:	e8 cd f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102df3:	e8 58 3c 00 00       	call   80106a50 <kvmalloc>
  mpinit();        // detect other processors
80102df8:	e8 73 01 00 00       	call   80102f70 <mpinit>
80102dfd:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e00:	e8 4b f8 ff ff       	call   80102650 <lapicinit>
  seginit();       // segment descriptors
80102e05:	e8 56 36 00 00       	call   80106460 <seginit>
  picinit();       // disable pic
80102e0a:	e8 21 03 00 00       	call   80103130 <picinit>
80102e0f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e10:	e8 cb f3 ff ff       	call   801021e0 <ioapicinit>
  consoleinit();   // console hardware
80102e15:	e8 36 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e1a:	e8 e1 29 00 00       	call   80105800 <uartinit>
80102e1f:	90                   	nop
  pinit();         // process table
80102e20:	e8 9b 07 00 00       	call   801035c0 <pinit>
  shminit();       // shared memory
80102e25:	e8 36 3e 00 00       	call   80106c60 <shminit>
  tvinit();        // trap vectors
80102e2a:	e8 11 26 00 00       	call   80105440 <tvinit>
80102e2f:	90                   	nop
  binit();         // buffer cache
80102e30:	e8 0b d2 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e35:	e8 e6 de ff ff       	call   80100d20 <fileinit>
  ideinit();       // disk 
80102e3a:	e8 a1 f1 ff ff       	call   80101fe0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e3f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e46:	00 
80102e47:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e4e:	80 
80102e4f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e56:	e8 a5 14 00 00       	call   80104300 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e5b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e62:	00 00 00 
80102e65:	05 80 27 11 80       	add    $0x80112780,%eax
80102e6a:	39 d8                	cmp    %ebx,%eax
80102e6c:	76 65                	jbe    80102ed3 <main+0x103>
80102e6e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e70:	e8 6b 07 00 00       	call   801035e0 <mycpu>
80102e75:	39 d8                	cmp    %ebx,%eax
80102e77:	74 41                	je     80102eba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e79:	e8 02 f6 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e7e:	c7 05 f8 6f 00 80 b0 	movl   $0x80102db0,0x80006ff8
80102e85:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e88:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e8f:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e92:	05 00 10 00 00       	add    $0x1000,%eax
80102e97:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102e9c:	0f b6 03             	movzbl (%ebx),%eax
80102e9f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ea6:	00 
80102ea7:	89 04 24             	mov    %eax,(%esp)
80102eaa:	e8 e1 f8 ff ff       	call   80102790 <lapicstartap>
80102eaf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102eb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102eb6:	85 c0                	test   %eax,%eax
80102eb8:	74 f6                	je     80102eb0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eba:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ec1:	00 00 00 
80102ec4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eca:	05 80 27 11 80       	add    $0x80112780,%eax
80102ecf:	39 c3                	cmp    %eax,%ebx
80102ed1:	72 9d                	jb     80102e70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ed3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eda:	8e 
80102edb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ee2:	e8 49 f5 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102ee7:	e8 c4 07 00 00       	call   801036b0 <userinit>
  mpmain();        // finish this processor's setup
80102eec:	e8 6f fe ff ff       	call   80102d60 <mpmain>
80102ef1:	66 90                	xchg   %ax,%ax
80102ef3:	66 90                	xchg   %ax,%ax
80102ef5:	66 90                	xchg   %ax,%ax
80102ef7:	66 90                	xchg   %ax,%ax
80102ef9:	66 90                	xchg   %ax,%ax
80102efb:	66 90                	xchg   %ax,%ax
80102efd:	66 90                	xchg   %ax,%ax
80102eff:	90                   	nop

80102f00 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f04:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f0a:	53                   	push   %ebx
  e = addr+len;
80102f0b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f0e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f11:	39 de                	cmp    %ebx,%esi
80102f13:	73 3c                	jae    80102f51 <mpsearch1+0x51>
80102f15:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f18:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f1f:	00 
80102f20:	c7 44 24 04 d8 71 10 	movl   $0x801071d8,0x4(%esp)
80102f27:	80 
80102f28:	89 34 24             	mov    %esi,(%esp)
80102f2b:	e8 80 13 00 00       	call   801042b0 <memcmp>
80102f30:	85 c0                	test   %eax,%eax
80102f32:	75 16                	jne    80102f4a <mpsearch1+0x4a>
80102f34:	31 c9                	xor    %ecx,%ecx
80102f36:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f38:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f3c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f3f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f41:	83 fa 10             	cmp    $0x10,%edx
80102f44:	75 f2                	jne    80102f38 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f46:	84 c9                	test   %cl,%cl
80102f48:	74 10                	je     80102f5a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f4a:	83 c6 10             	add    $0x10,%esi
80102f4d:	39 f3                	cmp    %esi,%ebx
80102f4f:	77 c7                	ja     80102f18 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f51:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f54:	31 c0                	xor    %eax,%eax
}
80102f56:	5b                   	pop    %ebx
80102f57:	5e                   	pop    %esi
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	89 f0                	mov    %esi,%eax
80102f5f:	5b                   	pop    %ebx
80102f60:	5e                   	pop    %esi
80102f61:	5d                   	pop    %ebp
80102f62:	c3                   	ret    
80102f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f70 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
80102f75:	53                   	push   %ebx
80102f76:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f79:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f80:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f87:	c1 e0 08             	shl    $0x8,%eax
80102f8a:	09 d0                	or     %edx,%eax
80102f8c:	c1 e0 04             	shl    $0x4,%eax
80102f8f:	85 c0                	test   %eax,%eax
80102f91:	75 1b                	jne    80102fae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102f93:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f9a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fa1:	c1 e0 08             	shl    $0x8,%eax
80102fa4:	09 d0                	or     %edx,%eax
80102fa6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fa9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fae:	ba 00 04 00 00       	mov    $0x400,%edx
80102fb3:	e8 48 ff ff ff       	call   80102f00 <mpsearch1>
80102fb8:	85 c0                	test   %eax,%eax
80102fba:	89 c7                	mov    %eax,%edi
80102fbc:	0f 84 22 01 00 00    	je     801030e4 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fc2:	8b 77 04             	mov    0x4(%edi),%esi
80102fc5:	85 f6                	test   %esi,%esi
80102fc7:	0f 84 30 01 00 00    	je     801030fd <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fcd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fd3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fda:	00 
80102fdb:	c7 44 24 04 dd 71 10 	movl   $0x801071dd,0x4(%esp)
80102fe2:	80 
80102fe3:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102fe9:	e8 c2 12 00 00       	call   801042b0 <memcmp>
80102fee:	85 c0                	test   %eax,%eax
80102ff0:	0f 85 07 01 00 00    	jne    801030fd <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80102ff6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102ffd:	3c 04                	cmp    $0x4,%al
80102fff:	0f 85 0b 01 00 00    	jne    80103110 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103005:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010300c:	85 c0                	test   %eax,%eax
8010300e:	74 21                	je     80103031 <mpinit+0xc1>
  sum = 0;
80103010:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103012:	31 d2                	xor    %edx,%edx
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103018:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010301f:	80 
  for(i=0; i<len; i++)
80103020:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103023:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103025:	39 d0                	cmp    %edx,%eax
80103027:	7f ef                	jg     80103018 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103029:	84 c9                	test   %cl,%cl
8010302b:	0f 85 cc 00 00 00    	jne    801030fd <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103034:	85 c0                	test   %eax,%eax
80103036:	0f 84 c1 00 00 00    	je     801030fd <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010303c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103042:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103047:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010304c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103053:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103059:	03 55 e4             	add    -0x1c(%ebp),%edx
8010305c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103060:	39 c2                	cmp    %eax,%edx
80103062:	76 1b                	jbe    8010307f <mpinit+0x10f>
80103064:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103067:	80 f9 04             	cmp    $0x4,%cl
8010306a:	77 74                	ja     801030e0 <mpinit+0x170>
8010306c:	ff 24 8d 1c 72 10 80 	jmp    *-0x7fef8de4(,%ecx,4)
80103073:	90                   	nop
80103074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103078:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307b:	39 c2                	cmp    %eax,%edx
8010307d:	77 e5                	ja     80103064 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010307f:	85 db                	test   %ebx,%ebx
80103081:	0f 84 93 00 00 00    	je     8010311a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103087:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010308b:	74 12                	je     8010309f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308d:	ba 22 00 00 00       	mov    $0x22,%edx
80103092:	b8 70 00 00 00       	mov    $0x70,%eax
80103097:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103098:	b2 23                	mov    $0x23,%dl
8010309a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010309b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309e:	ee                   	out    %al,(%dx)
  }
}
8010309f:	83 c4 1c             	add    $0x1c,%esp
801030a2:	5b                   	pop    %ebx
801030a3:	5e                   	pop    %esi
801030a4:	5f                   	pop    %edi
801030a5:	5d                   	pop    %ebp
801030a6:	c3                   	ret    
801030a7:	90                   	nop
      if(ncpu < NCPU) {
801030a8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ae:	83 fe 07             	cmp    $0x7,%esi
801030b1:	7f 17                	jg     801030ca <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030b3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030b7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030bd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030c4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030ca:	83 c0 14             	add    $0x14,%eax
      continue;
801030cd:	eb 91                	jmp    80103060 <mpinit+0xf0>
801030cf:	90                   	nop
      ioapicid = ioapic->apicno;
801030d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801030d7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801030dd:	eb 81                	jmp    80103060 <mpinit+0xf0>
801030df:	90                   	nop
      ismp = 0;
801030e0:	31 db                	xor    %ebx,%ebx
801030e2:	eb 83                	jmp    80103067 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
801030e4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030e9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030ee:	e8 0d fe ff ff       	call   80102f00 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030f3:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801030f5:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030f7:	0f 85 c5 fe ff ff    	jne    80102fc2 <mpinit+0x52>
    panic("Expect to run on an SMP");
801030fd:	c7 04 24 e2 71 10 80 	movl   $0x801071e2,(%esp)
80103104:	e8 57 d2 ff ff       	call   80100360 <panic>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103110:	3c 01                	cmp    $0x1,%al
80103112:	0f 84 ed fe ff ff    	je     80103005 <mpinit+0x95>
80103118:	eb e3                	jmp    801030fd <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010311a:	c7 04 24 fc 71 10 80 	movl   $0x801071fc,(%esp)
80103121:	e8 3a d2 ff ff       	call   80100360 <panic>
80103126:	66 90                	xchg   %ax,%ax
80103128:	66 90                	xchg   %ax,%ax
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103130:	55                   	push   %ebp
80103131:	ba 21 00 00 00       	mov    $0x21,%edx
80103136:	89 e5                	mov    %esp,%ebp
80103138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010313d:	ee                   	out    %al,(%dx)
8010313e:	b2 a1                	mov    $0xa1,%dl
80103140:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103141:	5d                   	pop    %ebp
80103142:	c3                   	ret    
80103143:	66 90                	xchg   %ax,%ax
80103145:	66 90                	xchg   %ax,%ax
80103147:	66 90                	xchg   %ax,%ax
80103149:	66 90                	xchg   %ax,%ax
8010314b:	66 90                	xchg   %ax,%ax
8010314d:	66 90                	xchg   %ax,%ax
8010314f:	90                   	nop

80103150 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	57                   	push   %edi
80103154:	56                   	push   %esi
80103155:	53                   	push   %ebx
80103156:	83 ec 1c             	sub    $0x1c,%esp
80103159:	8b 75 08             	mov    0x8(%ebp),%esi
8010315c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010315f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103165:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010316b:	e8 d0 db ff ff       	call   80100d40 <filealloc>
80103170:	85 c0                	test   %eax,%eax
80103172:	89 06                	mov    %eax,(%esi)
80103174:	0f 84 a4 00 00 00    	je     8010321e <pipealloc+0xce>
8010317a:	e8 c1 db ff ff       	call   80100d40 <filealloc>
8010317f:	85 c0                	test   %eax,%eax
80103181:	89 03                	mov    %eax,(%ebx)
80103183:	0f 84 87 00 00 00    	je     80103210 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103189:	e8 f2 f2 ff ff       	call   80102480 <kalloc>
8010318e:	85 c0                	test   %eax,%eax
80103190:	89 c7                	mov    %eax,%edi
80103192:	74 7c                	je     80103210 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103194:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010319b:	00 00 00 
  p->writeopen = 1;
8010319e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031a5:	00 00 00 
  p->nwrite = 0;
801031a8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031af:	00 00 00 
  p->nread = 0;
801031b2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031b9:	00 00 00 
  initlock(&p->lock, "pipe");
801031bc:	89 04 24             	mov    %eax,(%esp)
801031bf:	c7 44 24 04 30 72 10 	movl   $0x80107230,0x4(%esp)
801031c6:	80 
801031c7:	e8 64 0e 00 00       	call   80104030 <initlock>
  (*f0)->type = FD_PIPE;
801031cc:	8b 06                	mov    (%esi),%eax
801031ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031d4:	8b 06                	mov    (%esi),%eax
801031d6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031da:	8b 06                	mov    (%esi),%eax
801031dc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031e0:	8b 06                	mov    (%esi),%eax
801031e2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031e5:	8b 03                	mov    (%ebx),%eax
801031e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031ed:	8b 03                	mov    (%ebx),%eax
801031ef:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801031f3:	8b 03                	mov    (%ebx),%eax
801031f5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801031f9:	8b 03                	mov    (%ebx),%eax
  return 0;
801031fb:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
801031fd:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103200:	83 c4 1c             	add    $0x1c,%esp
80103203:	89 d8                	mov    %ebx,%eax
80103205:	5b                   	pop    %ebx
80103206:	5e                   	pop    %esi
80103207:	5f                   	pop    %edi
80103208:	5d                   	pop    %ebp
80103209:	c3                   	ret    
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103210:	8b 06                	mov    (%esi),%eax
80103212:	85 c0                	test   %eax,%eax
80103214:	74 08                	je     8010321e <pipealloc+0xce>
    fileclose(*f0);
80103216:	89 04 24             	mov    %eax,(%esp)
80103219:	e8 e2 db ff ff       	call   80100e00 <fileclose>
  if(*f1)
8010321e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103220:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103225:	85 c0                	test   %eax,%eax
80103227:	74 d7                	je     80103200 <pipealloc+0xb0>
    fileclose(*f1);
80103229:	89 04 24             	mov    %eax,(%esp)
8010322c:	e8 cf db ff ff       	call   80100e00 <fileclose>
}
80103231:	83 c4 1c             	add    $0x1c,%esp
80103234:	89 d8                	mov    %ebx,%eax
80103236:	5b                   	pop    %ebx
80103237:	5e                   	pop    %esi
80103238:	5f                   	pop    %edi
80103239:	5d                   	pop    %ebp
8010323a:	c3                   	ret    
8010323b:	90                   	nop
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103240 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	56                   	push   %esi
80103244:	53                   	push   %ebx
80103245:	83 ec 10             	sub    $0x10,%esp
80103248:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010324e:	89 1c 24             	mov    %ebx,(%esp)
80103251:	e8 ca 0e 00 00       	call   80104120 <acquire>
  if(writable){
80103256:	85 f6                	test   %esi,%esi
80103258:	74 3e                	je     80103298 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010325a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103260:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103267:	00 00 00 
    wakeup(&p->nread);
8010326a:	89 04 24             	mov    %eax,(%esp)
8010326d:	e8 fe 0a 00 00       	call   80103d70 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103272:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103278:	85 d2                	test   %edx,%edx
8010327a:	75 0a                	jne    80103286 <pipeclose+0x46>
8010327c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103282:	85 c0                	test   %eax,%eax
80103284:	74 32                	je     801032b8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103286:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	5b                   	pop    %ebx
8010328d:	5e                   	pop    %esi
8010328e:	5d                   	pop    %ebp
    release(&p->lock);
8010328f:	e9 7c 0f 00 00       	jmp    80104210 <release>
80103294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103298:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
8010329e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032a5:	00 00 00 
    wakeup(&p->nwrite);
801032a8:	89 04 24             	mov    %eax,(%esp)
801032ab:	e8 c0 0a 00 00       	call   80103d70 <wakeup>
801032b0:	eb c0                	jmp    80103272 <pipeclose+0x32>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032b8:	89 1c 24             	mov    %ebx,(%esp)
801032bb:	e8 50 0f 00 00       	call   80104210 <release>
    kfree((char*)p);
801032c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032c3:	83 c4 10             	add    $0x10,%esp
801032c6:	5b                   	pop    %ebx
801032c7:	5e                   	pop    %esi
801032c8:	5d                   	pop    %ebp
    kfree((char*)p);
801032c9:	e9 02 f0 ff ff       	jmp    801022d0 <kfree>
801032ce:	66 90                	xchg   %ax,%ax

801032d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 1c             	sub    $0x1c,%esp
801032d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032dc:	89 1c 24             	mov    %ebx,(%esp)
801032df:	e8 3c 0e 00 00       	call   80104120 <acquire>
  for(i = 0; i < n; i++){
801032e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032e7:	85 c9                	test   %ecx,%ecx
801032e9:	0f 8e b2 00 00 00    	jle    801033a1 <pipewrite+0xd1>
801032ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801032f2:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801032f8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032fe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103304:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103307:	03 4d 10             	add    0x10(%ebp),%ecx
8010330a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010330d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103313:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103319:	39 c8                	cmp    %ecx,%eax
8010331b:	74 38                	je     80103355 <pipewrite+0x85>
8010331d:	eb 55                	jmp    80103374 <pipewrite+0xa4>
8010331f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103320:	e8 5b 03 00 00       	call   80103680 <myproc>
80103325:	8b 40 24             	mov    0x24(%eax),%eax
80103328:	85 c0                	test   %eax,%eax
8010332a:	75 33                	jne    8010335f <pipewrite+0x8f>
      wakeup(&p->nread);
8010332c:	89 3c 24             	mov    %edi,(%esp)
8010332f:	e8 3c 0a 00 00       	call   80103d70 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103334:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103338:	89 34 24             	mov    %esi,(%esp)
8010333b:	e8 a0 08 00 00       	call   80103be0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103340:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103346:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010334c:	05 00 02 00 00       	add    $0x200,%eax
80103351:	39 c2                	cmp    %eax,%edx
80103353:	75 23                	jne    80103378 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103355:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010335b:	85 d2                	test   %edx,%edx
8010335d:	75 c1                	jne    80103320 <pipewrite+0x50>
        release(&p->lock);
8010335f:	89 1c 24             	mov    %ebx,(%esp)
80103362:	e8 a9 0e 00 00       	call   80104210 <release>
        return -1;
80103367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010336c:	83 c4 1c             	add    $0x1c,%esp
8010336f:	5b                   	pop    %ebx
80103370:	5e                   	pop    %esi
80103371:	5f                   	pop    %edi
80103372:	5d                   	pop    %ebp
80103373:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103374:	89 c2                	mov    %eax,%edx
80103376:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103378:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010337b:	8d 42 01             	lea    0x1(%edx),%eax
8010337e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103384:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010338a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010338e:	0f b6 09             	movzbl (%ecx),%ecx
80103391:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103395:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103398:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010339b:	0f 85 6c ff ff ff    	jne    8010330d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033a1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033a7:	89 04 24             	mov    %eax,(%esp)
801033aa:	e8 c1 09 00 00       	call   80103d70 <wakeup>
  release(&p->lock);
801033af:	89 1c 24             	mov    %ebx,(%esp)
801033b2:	e8 59 0e 00 00       	call   80104210 <release>
  return n;
801033b7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ba:	eb b0                	jmp    8010336c <pipewrite+0x9c>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
801033c9:	8b 75 08             	mov    0x8(%ebp),%esi
801033cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033cf:	89 34 24             	mov    %esi,(%esp)
801033d2:	e8 49 0d 00 00       	call   80104120 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033d7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033dd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033e3:	75 5b                	jne    80103440 <piperead+0x80>
801033e5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033eb:	85 db                	test   %ebx,%ebx
801033ed:	74 51                	je     80103440 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033ef:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801033f5:	eb 25                	jmp    8010341c <piperead+0x5c>
801033f7:	90                   	nop
801033f8:	89 74 24 04          	mov    %esi,0x4(%esp)
801033fc:	89 1c 24             	mov    %ebx,(%esp)
801033ff:	e8 dc 07 00 00       	call   80103be0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103404:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103410:	75 2e                	jne    80103440 <piperead+0x80>
80103412:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103418:	85 d2                	test   %edx,%edx
8010341a:	74 24                	je     80103440 <piperead+0x80>
    if(myproc()->killed){
8010341c:	e8 5f 02 00 00       	call   80103680 <myproc>
80103421:	8b 48 24             	mov    0x24(%eax),%ecx
80103424:	85 c9                	test   %ecx,%ecx
80103426:	74 d0                	je     801033f8 <piperead+0x38>
      release(&p->lock);
80103428:	89 34 24             	mov    %esi,(%esp)
8010342b:	e8 e0 0d 00 00       	call   80104210 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103430:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103438:	5b                   	pop    %ebx
80103439:	5e                   	pop    %esi
8010343a:	5f                   	pop    %edi
8010343b:	5d                   	pop    %ebp
8010343c:	c3                   	ret    
8010343d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103440:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103443:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103445:	85 d2                	test   %edx,%edx
80103447:	7f 2b                	jg     80103474 <piperead+0xb4>
80103449:	eb 31                	jmp    8010347c <piperead+0xbc>
8010344b:	90                   	nop
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103450:	8d 48 01             	lea    0x1(%eax),%ecx
80103453:	25 ff 01 00 00       	and    $0x1ff,%eax
80103458:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010345e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103463:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103466:	83 c3 01             	add    $0x1,%ebx
80103469:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010346c:	74 0e                	je     8010347c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010346e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103474:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010347a:	75 d4                	jne    80103450 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010347c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103482:	89 04 24             	mov    %eax,(%esp)
80103485:	e8 e6 08 00 00       	call   80103d70 <wakeup>
  release(&p->lock);
8010348a:	89 34 24             	mov    %esi,(%esp)
8010348d:	e8 7e 0d 00 00       	call   80104210 <release>
}
80103492:	83 c4 1c             	add    $0x1c,%esp
  return i;
80103495:	89 d8                	mov    %ebx,%eax
}
80103497:	5b                   	pop    %ebx
80103498:	5e                   	pop    %esi
80103499:	5f                   	pop    %edi
8010349a:	5d                   	pop    %ebp
8010349b:	c3                   	ret    
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034a9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034ac:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034b3:	e8 68 0c 00 00       	call   80104120 <acquire>
801034b8:	eb 11                	jmp    801034cb <allocproc+0x2b>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034c0:	83 c3 7c             	add    $0x7c,%ebx
801034c3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801034c9:	74 7d                	je     80103548 <allocproc+0xa8>
    if(p->state == UNUSED)
801034cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034ce:	85 c0                	test   %eax,%eax
801034d0:	75 ee                	jne    801034c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034d7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801034de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801034e5:	8d 50 01             	lea    0x1(%eax),%edx
801034e8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801034ee:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801034f1:	e8 1a 0d 00 00       	call   80104210 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801034f6:	e8 85 ef ff ff       	call   80102480 <kalloc>
801034fb:	85 c0                	test   %eax,%eax
801034fd:	89 43 08             	mov    %eax,0x8(%ebx)
80103500:	74 5a                	je     8010355c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103502:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103508:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010350d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103510:	c7 40 14 35 54 10 80 	movl   $0x80105435,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103517:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010351e:	00 
8010351f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103526:	00 
80103527:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010352a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010352d:	e8 2e 0d 00 00       	call   80104260 <memset>
  p->context->eip = (uint)forkret;
80103532:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103535:	c7 40 10 70 35 10 80 	movl   $0x80103570,0x10(%eax)

  return p;
8010353c:	89 d8                	mov    %ebx,%eax
}
8010353e:	83 c4 14             	add    $0x14,%esp
80103541:	5b                   	pop    %ebx
80103542:	5d                   	pop    %ebp
80103543:	c3                   	ret    
80103544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103548:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010354f:	e8 bc 0c 00 00       	call   80104210 <release>
}
80103554:	83 c4 14             	add    $0x14,%esp
  return 0;
80103557:	31 c0                	xor    %eax,%eax
}
80103559:	5b                   	pop    %ebx
8010355a:	5d                   	pop    %ebp
8010355b:	c3                   	ret    
    p->state = UNUSED;
8010355c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103563:	eb d9                	jmp    8010353e <allocproc+0x9e>
80103565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103570 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103576:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010357d:	e8 8e 0c 00 00       	call   80104210 <release>

  if (first) {
80103582:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	75 05                	jne    80103590 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010358b:	c9                   	leave  
8010358c:	c3                   	ret    
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
80103590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103597:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010359e:	00 00 00 
    iinit(ROOTDEV);
801035a1:	e8 aa de ff ff       	call   80101450 <iinit>
    initlog(ROOTDEV);
801035a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ad:	e8 9e f4 ff ff       	call   80102a50 <initlog>
}
801035b2:	c9                   	leave  
801035b3:	c3                   	ret    
801035b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035c0 <pinit>:
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035c6:	c7 44 24 04 35 72 10 	movl   $0x80107235,0x4(%esp)
801035cd:	80 
801035ce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035d5:	e8 56 0a 00 00       	call   80104030 <initlock>
}
801035da:	c9                   	leave  
801035db:	c3                   	ret    
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035e0 <mycpu>:
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	56                   	push   %esi
801035e4:	53                   	push   %ebx
801035e5:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035e8:	9c                   	pushf  
801035e9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035ea:	f6 c4 02             	test   $0x2,%ah
801035ed:	75 57                	jne    80103646 <mycpu+0x66>
  apicid = lapicid();
801035ef:	e8 4c f1 ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801035f4:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801035fa:	85 f6                	test   %esi,%esi
801035fc:	7e 3c                	jle    8010363a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801035fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103605:	39 c2                	cmp    %eax,%edx
80103607:	74 2d                	je     80103636 <mycpu+0x56>
80103609:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010360e:	31 d2                	xor    %edx,%edx
80103610:	83 c2 01             	add    $0x1,%edx
80103613:	39 f2                	cmp    %esi,%edx
80103615:	74 23                	je     8010363a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103617:	0f b6 19             	movzbl (%ecx),%ebx
8010361a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103620:	39 c3                	cmp    %eax,%ebx
80103622:	75 ec                	jne    80103610 <mycpu+0x30>
      return &cpus[i];
80103624:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010362a:	83 c4 10             	add    $0x10,%esp
8010362d:	5b                   	pop    %ebx
8010362e:	5e                   	pop    %esi
8010362f:	5d                   	pop    %ebp
      return &cpus[i];
80103630:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103635:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103636:	31 d2                	xor    %edx,%edx
80103638:	eb ea                	jmp    80103624 <mycpu+0x44>
  panic("unknown apicid\n");
8010363a:	c7 04 24 3c 72 10 80 	movl   $0x8010723c,(%esp)
80103641:	e8 1a cd ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103646:	c7 04 24 18 73 10 80 	movl   $0x80107318,(%esp)
8010364d:	e8 0e cd ff ff       	call   80100360 <panic>
80103652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103660 <cpuid>:
cpuid() {
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103666:	e8 75 ff ff ff       	call   801035e0 <mycpu>
}
8010366b:	c9                   	leave  
  return mycpu()-cpus;
8010366c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103671:	c1 f8 04             	sar    $0x4,%eax
80103674:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010367a:	c3                   	ret    
8010367b:	90                   	nop
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103680 <myproc>:
myproc(void) {
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	53                   	push   %ebx
80103684:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103687:	e8 54 0a 00 00       	call   801040e0 <pushcli>
  c = mycpu();
8010368c:	e8 4f ff ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103691:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103697:	e8 04 0b 00 00       	call   801041a0 <popcli>
}
8010369c:	83 c4 04             	add    $0x4,%esp
8010369f:	89 d8                	mov    %ebx,%eax
801036a1:	5b                   	pop    %ebx
801036a2:	5d                   	pop    %ebp
801036a3:	c3                   	ret    
801036a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036b0 <userinit>:
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036b7:	e8 e4 fd ff ff       	call   801034a0 <allocproc>
801036bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036be:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036c3:	e8 f8 32 00 00       	call   801069c0 <setupkvm>
801036c8:	85 c0                	test   %eax,%eax
801036ca:	89 43 04             	mov    %eax,0x4(%ebx)
801036cd:	0f 84 d4 00 00 00    	je     801037a7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036d3:	89 04 24             	mov    %eax,(%esp)
801036d6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036dd:	00 
801036de:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036e5:	80 
801036e6:	e8 e5 2f 00 00       	call   801066d0 <inituvm>
  p->sz = PGSIZE;
801036eb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801036f1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801036f8:	00 
801036f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103700:	00 
80103701:	8b 43 18             	mov    0x18(%ebx),%eax
80103704:	89 04 24             	mov    %eax,(%esp)
80103707:	e8 54 0b 00 00       	call   80104260 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010370c:	8b 43 18             	mov    0x18(%ebx),%eax
8010370f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103714:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103719:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010371d:	8b 43 18             	mov    0x18(%ebx),%eax
80103720:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103724:	8b 43 18             	mov    0x18(%ebx),%eax
80103727:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010372b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010372f:	8b 43 18             	mov    0x18(%ebx),%eax
80103732:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103736:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010373a:	8b 43 18             	mov    0x18(%ebx),%eax
8010373d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103744:	8b 43 18             	mov    0x18(%ebx),%eax
80103747:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010374e:	8b 43 18             	mov    0x18(%ebx),%eax
80103751:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103758:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010375b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103762:	00 
80103763:	c7 44 24 04 65 72 10 	movl   $0x80107265,0x4(%esp)
8010376a:	80 
8010376b:	89 04 24             	mov    %eax,(%esp)
8010376e:	e8 cd 0c 00 00       	call   80104440 <safestrcpy>
  p->cwd = namei("/");
80103773:	c7 04 24 6e 72 10 80 	movl   $0x8010726e,(%esp)
8010377a:	e8 61 e7 ff ff       	call   80101ee0 <namei>
8010377f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103782:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103789:	e8 92 09 00 00       	call   80104120 <acquire>
  p->state = RUNNABLE;
8010378e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103795:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010379c:	e8 6f 0a 00 00       	call   80104210 <release>
}
801037a1:	83 c4 14             	add    $0x14,%esp
801037a4:	5b                   	pop    %ebx
801037a5:	5d                   	pop    %ebp
801037a6:	c3                   	ret    
    panic("userinit: out of memory?");
801037a7:	c7 04 24 4c 72 10 80 	movl   $0x8010724c,(%esp)
801037ae:	e8 ad cb ff ff       	call   80100360 <panic>
801037b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037c0 <growproc>:
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	83 ec 10             	sub    $0x10,%esp
801037c8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037cb:	e8 b0 fe ff ff       	call   80103680 <myproc>
  if(n > 0){
801037d0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801037d3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801037d5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037d7:	7e 2f                	jle    80103808 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037d9:	01 c6                	add    %eax,%esi
801037db:	89 74 24 08          	mov    %esi,0x8(%esp)
801037df:	89 44 24 04          	mov    %eax,0x4(%esp)
801037e3:	8b 43 04             	mov    0x4(%ebx),%eax
801037e6:	89 04 24             	mov    %eax,(%esp)
801037e9:	e8 32 30 00 00       	call   80106820 <allocuvm>
801037ee:	85 c0                	test   %eax,%eax
801037f0:	74 36                	je     80103828 <growproc+0x68>
  curproc->sz = sz;
801037f2:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801037f4:	89 1c 24             	mov    %ebx,(%esp)
801037f7:	e8 c4 2d 00 00       	call   801065c0 <switchuvm>
  return 0;
801037fc:	31 c0                	xor    %eax,%eax
}
801037fe:	83 c4 10             	add    $0x10,%esp
80103801:	5b                   	pop    %ebx
80103802:	5e                   	pop    %esi
80103803:	5d                   	pop    %ebp
80103804:	c3                   	ret    
80103805:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103808:	74 e8                	je     801037f2 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010380a:	01 c6                	add    %eax,%esi
8010380c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103810:	89 44 24 04          	mov    %eax,0x4(%esp)
80103814:	8b 43 04             	mov    0x4(%ebx),%eax
80103817:	89 04 24             	mov    %eax,(%esp)
8010381a:	e8 01 31 00 00       	call   80106920 <deallocuvm>
8010381f:	85 c0                	test   %eax,%eax
80103821:	75 cf                	jne    801037f2 <growproc+0x32>
80103823:	90                   	nop
80103824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010382d:	eb cf                	jmp    801037fe <growproc+0x3e>
8010382f:	90                   	nop

80103830 <fork>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103839:	e8 42 fe ff ff       	call   80103680 <myproc>
8010383e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103840:	e8 5b fc ff ff       	call   801034a0 <allocproc>
80103845:	85 c0                	test   %eax,%eax
80103847:	89 c7                	mov    %eax,%edi
80103849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010384c:	0f 84 bc 00 00 00    	je     8010390e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103852:	8b 03                	mov    (%ebx),%eax
80103854:	89 44 24 04          	mov    %eax,0x4(%esp)
80103858:	8b 43 04             	mov    0x4(%ebx),%eax
8010385b:	89 04 24             	mov    %eax,(%esp)
8010385e:	e8 3d 32 00 00       	call   80106aa0 <copyuvm>
80103863:	85 c0                	test   %eax,%eax
80103865:	89 47 04             	mov    %eax,0x4(%edi)
80103868:	0f 84 a7 00 00 00    	je     80103915 <fork+0xe5>
  np->sz = curproc->sz;
8010386e:	8b 03                	mov    (%ebx),%eax
80103870:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103873:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103875:	8b 79 18             	mov    0x18(%ecx),%edi
80103878:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
8010387a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010387d:	8b 73 18             	mov    0x18(%ebx),%esi
80103880:	b9 13 00 00 00       	mov    $0x13,%ecx
80103885:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103887:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103889:	8b 40 18             	mov    0x18(%eax),%eax
8010388c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103893:	90                   	nop
80103894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103898:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010389c:	85 c0                	test   %eax,%eax
8010389e:	74 0f                	je     801038af <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038a0:	89 04 24             	mov    %eax,(%esp)
801038a3:	e8 08 d5 ff ff       	call   80100db0 <filedup>
801038a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038ab:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038af:	83 c6 01             	add    $0x1,%esi
801038b2:	83 fe 10             	cmp    $0x10,%esi
801038b5:	75 e1                	jne    80103898 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038b7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038ba:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038bd:	89 04 24             	mov    %eax,(%esp)
801038c0:	e8 9b dd ff ff       	call   80101660 <idup>
801038c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038c8:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038cb:	8d 47 6c             	lea    0x6c(%edi),%eax
801038ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038d2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038d9:	00 
801038da:	89 04 24             	mov    %eax,(%esp)
801038dd:	e8 5e 0b 00 00       	call   80104440 <safestrcpy>
  pid = np->pid;
801038e2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801038e5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038ec:	e8 2f 08 00 00       	call   80104120 <acquire>
  np->state = RUNNABLE;
801038f1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801038f8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038ff:	e8 0c 09 00 00       	call   80104210 <release>
  return pid;
80103904:	89 d8                	mov    %ebx,%eax
}
80103906:	83 c4 1c             	add    $0x1c,%esp
80103909:	5b                   	pop    %ebx
8010390a:	5e                   	pop    %esi
8010390b:	5f                   	pop    %edi
8010390c:	5d                   	pop    %ebp
8010390d:	c3                   	ret    
    return -1;
8010390e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103913:	eb f1                	jmp    80103906 <fork+0xd6>
    kfree(np->kstack);
80103915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103918:	8b 47 08             	mov    0x8(%edi),%eax
8010391b:	89 04 24             	mov    %eax,(%esp)
8010391e:	e8 ad e9 ff ff       	call   801022d0 <kfree>
    return -1;
80103923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103928:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010392f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103936:	eb ce                	jmp    80103906 <fork+0xd6>
80103938:	90                   	nop
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103940 <scheduler>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103949:	e8 92 fc ff ff       	call   801035e0 <mycpu>
8010394e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103950:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103957:	00 00 00 
8010395a:	8d 78 04             	lea    0x4(%eax),%edi
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103960:	fb                   	sti    
    acquire(&ptable.lock);
80103961:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103968:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010396d:	e8 ae 07 00 00       	call   80104120 <acquire>
80103972:	eb 0f                	jmp    80103983 <scheduler+0x43>
80103974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103978:	83 c3 7c             	add    $0x7c,%ebx
8010397b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103981:	74 45                	je     801039c8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103983:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103987:	75 ef                	jne    80103978 <scheduler+0x38>
      c->proc = p;
80103989:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010398f:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103992:	83 c3 7c             	add    $0x7c,%ebx
      switchuvm(p);
80103995:	e8 26 2c 00 00       	call   801065c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
8010399a:	8b 43 a0             	mov    -0x60(%ebx),%eax
      p->state = RUNNING;
8010399d:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&(c->scheduler), p->context);
801039a4:	89 3c 24             	mov    %edi,(%esp)
801039a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ab:	e8 eb 0a 00 00       	call   8010449b <swtch>
      switchkvm();
801039b0:	e8 eb 2b 00 00       	call   801065a0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      c->proc = 0;
801039bb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039c2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c5:	75 bc                	jne    80103983 <scheduler+0x43>
801039c7:	90                   	nop
    release(&ptable.lock);
801039c8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039cf:	e8 3c 08 00 00       	call   80104210 <release>
  }
801039d4:	eb 8a                	jmp    80103960 <scheduler+0x20>
801039d6:	8d 76 00             	lea    0x0(%esi),%esi
801039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039e0 <sched>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	56                   	push   %esi
801039e4:	53                   	push   %ebx
801039e5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
801039e8:	e8 93 fc ff ff       	call   80103680 <myproc>
  if(!holding(&ptable.lock))
801039ed:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
801039f4:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801039f6:	e8 b5 06 00 00       	call   801040b0 <holding>
801039fb:	85 c0                	test   %eax,%eax
801039fd:	74 4f                	je     80103a4e <sched+0x6e>
  if(mycpu()->ncli != 1)
801039ff:	e8 dc fb ff ff       	call   801035e0 <mycpu>
80103a04:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a0b:	75 65                	jne    80103a72 <sched+0x92>
  if(p->state == RUNNING)
80103a0d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a11:	74 53                	je     80103a66 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a13:	9c                   	pushf  
80103a14:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a15:	f6 c4 02             	test   $0x2,%ah
80103a18:	75 40                	jne    80103a5a <sched+0x7a>
  intena = mycpu()->intena;
80103a1a:	e8 c1 fb ff ff       	call   801035e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a1f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a22:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a28:	e8 b3 fb ff ff       	call   801035e0 <mycpu>
80103a2d:	8b 40 04             	mov    0x4(%eax),%eax
80103a30:	89 1c 24             	mov    %ebx,(%esp)
80103a33:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a37:	e8 5f 0a 00 00       	call   8010449b <swtch>
  mycpu()->intena = intena;
80103a3c:	e8 9f fb ff ff       	call   801035e0 <mycpu>
80103a41:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a47:	83 c4 10             	add    $0x10,%esp
80103a4a:	5b                   	pop    %ebx
80103a4b:	5e                   	pop    %esi
80103a4c:	5d                   	pop    %ebp
80103a4d:	c3                   	ret    
    panic("sched ptable.lock");
80103a4e:	c7 04 24 70 72 10 80 	movl   $0x80107270,(%esp)
80103a55:	e8 06 c9 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a5a:	c7 04 24 9c 72 10 80 	movl   $0x8010729c,(%esp)
80103a61:	e8 fa c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a66:	c7 04 24 8e 72 10 80 	movl   $0x8010728e,(%esp)
80103a6d:	e8 ee c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103a72:	c7 04 24 82 72 10 80 	movl   $0x80107282,(%esp)
80103a79:	e8 e2 c8 ff ff       	call   80100360 <panic>
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <exit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
  if(curproc == initproc)
80103a84:	31 f6                	xor    %esi,%esi
{
80103a86:	53                   	push   %ebx
80103a87:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103a8a:	e8 f1 fb ff ff       	call   80103680 <myproc>
  if(curproc == initproc)
80103a8f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103a95:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103a97:	0f 84 ea 00 00 00    	je     80103b87 <exit+0x107>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103aa0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103aa4:	85 c0                	test   %eax,%eax
80103aa6:	74 10                	je     80103ab8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103aa8:	89 04 24             	mov    %eax,(%esp)
80103aab:	e8 50 d3 ff ff       	call   80100e00 <fileclose>
      curproc->ofile[fd] = 0;
80103ab0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ab7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103ab8:	83 c6 01             	add    $0x1,%esi
80103abb:	83 fe 10             	cmp    $0x10,%esi
80103abe:	75 e0                	jne    80103aa0 <exit+0x20>
  begin_op();
80103ac0:	e8 2b f0 ff ff       	call   80102af0 <begin_op>
  iput(curproc->cwd);
80103ac5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ac8:	89 04 24             	mov    %eax,(%esp)
80103acb:	e8 e0 dc ff ff       	call   801017b0 <iput>
  end_op();
80103ad0:	e8 8b f0 ff ff       	call   80102b60 <end_op>
  curproc->cwd = 0;
80103ad5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103adc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ae3:	e8 38 06 00 00       	call   80104120 <acquire>
  wakeup1(curproc->parent);
80103ae8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aeb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103af0:	eb 11                	jmp    80103b03 <exit+0x83>
80103af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103af8:	83 c2 7c             	add    $0x7c,%edx
80103afb:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b01:	74 1d                	je     80103b20 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b03:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b07:	75 ef                	jne    80103af8 <exit+0x78>
80103b09:	3b 42 20             	cmp    0x20(%edx),%eax
80103b0c:	75 ea                	jne    80103af8 <exit+0x78>
      p->state = RUNNABLE;
80103b0e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b15:	83 c2 7c             	add    $0x7c,%edx
80103b18:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b1e:	75 e3                	jne    80103b03 <exit+0x83>
      p->parent = initproc;
80103b20:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b25:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b2a:	eb 0f                	jmp    80103b3b <exit+0xbb>
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b30:	83 c1 7c             	add    $0x7c,%ecx
80103b33:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103b39:	74 34                	je     80103b6f <exit+0xef>
    if(p->parent == curproc){
80103b3b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b3e:	75 f0                	jne    80103b30 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b40:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b44:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b47:	75 e7                	jne    80103b30 <exit+0xb0>
80103b49:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b4e:	eb 0b                	jmp    80103b5b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b50:	83 c2 7c             	add    $0x7c,%edx
80103b53:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b59:	74 d5                	je     80103b30 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b5b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b5f:	75 ef                	jne    80103b50 <exit+0xd0>
80103b61:	3b 42 20             	cmp    0x20(%edx),%eax
80103b64:	75 ea                	jne    80103b50 <exit+0xd0>
      p->state = RUNNABLE;
80103b66:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b6d:	eb e1                	jmp    80103b50 <exit+0xd0>
  curproc->state = ZOMBIE;
80103b6f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b76:	e8 65 fe ff ff       	call   801039e0 <sched>
  panic("zombie exit");
80103b7b:	c7 04 24 bd 72 10 80 	movl   $0x801072bd,(%esp)
80103b82:	e8 d9 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103b87:	c7 04 24 b0 72 10 80 	movl   $0x801072b0,(%esp)
80103b8e:	e8 cd c7 ff ff       	call   80100360 <panic>
80103b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <yield>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ba6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bad:	e8 6e 05 00 00       	call   80104120 <acquire>
  myproc()->state = RUNNABLE;
80103bb2:	e8 c9 fa ff ff       	call   80103680 <myproc>
80103bb7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bbe:	e8 1d fe ff ff       	call   801039e0 <sched>
  release(&ptable.lock);
80103bc3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bca:	e8 41 06 00 00       	call   80104210 <release>
}
80103bcf:	c9                   	leave  
80103bd0:	c3                   	ret    
80103bd1:	eb 0d                	jmp    80103be0 <sleep>
80103bd3:	90                   	nop
80103bd4:	90                   	nop
80103bd5:	90                   	nop
80103bd6:	90                   	nop
80103bd7:	90                   	nop
80103bd8:	90                   	nop
80103bd9:	90                   	nop
80103bda:	90                   	nop
80103bdb:	90                   	nop
80103bdc:	90                   	nop
80103bdd:	90                   	nop
80103bde:	90                   	nop
80103bdf:	90                   	nop

80103be0 <sleep>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
80103be9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103bef:	e8 8c fa ff ff       	call   80103680 <myproc>
  if(p == 0)
80103bf4:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103bf6:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103bf8:	0f 84 7c 00 00 00    	je     80103c7a <sleep+0x9a>
  if(lk == 0)
80103bfe:	85 f6                	test   %esi,%esi
80103c00:	74 6c                	je     80103c6e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c02:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c08:	74 46                	je     80103c50 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c0a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c11:	e8 0a 05 00 00       	call   80104120 <acquire>
    release(lk);
80103c16:	89 34 24             	mov    %esi,(%esp)
80103c19:	e8 f2 05 00 00       	call   80104210 <release>
  p->chan = chan;
80103c1e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c21:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c28:	e8 b3 fd ff ff       	call   801039e0 <sched>
  p->chan = 0;
80103c2d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c34:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c3b:	e8 d0 05 00 00       	call   80104210 <release>
    acquire(lk);
80103c40:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c43:	83 c4 1c             	add    $0x1c,%esp
80103c46:	5b                   	pop    %ebx
80103c47:	5e                   	pop    %esi
80103c48:	5f                   	pop    %edi
80103c49:	5d                   	pop    %ebp
    acquire(lk);
80103c4a:	e9 d1 04 00 00       	jmp    80104120 <acquire>
80103c4f:	90                   	nop
  p->chan = chan;
80103c50:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c53:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103c5a:	e8 81 fd ff ff       	call   801039e0 <sched>
  p->chan = 0;
80103c5f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c66:	83 c4 1c             	add    $0x1c,%esp
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5f                   	pop    %edi
80103c6c:	5d                   	pop    %ebp
80103c6d:	c3                   	ret    
    panic("sleep without lk");
80103c6e:	c7 04 24 cf 72 10 80 	movl   $0x801072cf,(%esp)
80103c75:	e8 e6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103c7a:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
80103c81:	e8 da c6 ff ff       	call   80100360 <panic>
80103c86:	8d 76 00             	lea    0x0(%esi),%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <wait>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
80103c95:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103c98:	e8 e3 f9 ff ff       	call   80103680 <myproc>
  acquire(&ptable.lock);
80103c9d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103ca4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103ca6:	e8 75 04 00 00       	call   80104120 <acquire>
    havekids = 0;
80103cab:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cad:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cb2:	eb 0f                	jmp    80103cc3 <wait+0x33>
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cb8:	83 c3 7c             	add    $0x7c,%ebx
80103cbb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cc1:	74 1d                	je     80103ce0 <wait+0x50>
      if(p->parent != curproc)
80103cc3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103cc6:	75 f0                	jne    80103cb8 <wait+0x28>
      if(p->state == ZOMBIE){
80103cc8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ccc:	74 2f                	je     80103cfd <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103cd1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cdc:	75 e5                	jne    80103cc3 <wait+0x33>
80103cde:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103ce0:	85 c0                	test   %eax,%eax
80103ce2:	74 6e                	je     80103d52 <wait+0xc2>
80103ce4:	8b 46 24             	mov    0x24(%esi),%eax
80103ce7:	85 c0                	test   %eax,%eax
80103ce9:	75 67                	jne    80103d52 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ceb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103cf2:	80 
80103cf3:	89 34 24             	mov    %esi,(%esp)
80103cf6:	e8 e5 fe ff ff       	call   80103be0 <sleep>
  }
80103cfb:	eb ae                	jmp    80103cab <wait+0x1b>
        kfree(p->kstack);
80103cfd:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d00:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d03:	89 04 24             	mov    %eax,(%esp)
80103d06:	e8 c5 e5 ff ff       	call   801022d0 <kfree>
        freevm(p->pgdir);
80103d0b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d15:	89 04 24             	mov    %eax,(%esp)
80103d18:	e8 23 2c 00 00       	call   80106940 <freevm>
        release(&ptable.lock);
80103d1d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d24:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d2b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d32:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d36:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d3d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d44:	e8 c7 04 00 00       	call   80104210 <release>
}
80103d49:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d4c:	89 f0                	mov    %esi,%eax
}
80103d4e:	5b                   	pop    %ebx
80103d4f:	5e                   	pop    %esi
80103d50:	5d                   	pop    %ebp
80103d51:	c3                   	ret    
      release(&ptable.lock);
80103d52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d59:	e8 b2 04 00 00       	call   80104210 <release>
}
80103d5e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d66:	5b                   	pop    %ebx
80103d67:	5e                   	pop    %esi
80103d68:	5d                   	pop    %ebp
80103d69:	c3                   	ret    
80103d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d70 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 14             	sub    $0x14,%esp
80103d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103d7a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d81:	e8 9a 03 00 00       	call   80104120 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d86:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d8b:	eb 0d                	jmp    80103d9a <wakeup+0x2a>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
80103d90:	83 c0 7c             	add    $0x7c,%eax
80103d93:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d98:	74 1e                	je     80103db8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103d9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d9e:	75 f0                	jne    80103d90 <wakeup+0x20>
80103da0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103da3:	75 eb                	jne    80103d90 <wakeup+0x20>
      p->state = RUNNABLE;
80103da5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dac:	83 c0 7c             	add    $0x7c,%eax
80103daf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103db4:	75 e4                	jne    80103d9a <wakeup+0x2a>
80103db6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103db8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103dbf:	83 c4 14             	add    $0x14,%esp
80103dc2:	5b                   	pop    %ebx
80103dc3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103dc4:	e9 47 04 00 00       	jmp    80104210 <release>
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 14             	sub    $0x14,%esp
80103dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103dda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de1:	e8 3a 03 00 00       	call   80104120 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103deb:	eb 0d                	jmp    80103dfa <kill+0x2a>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
80103df0:	83 c0 7c             	add    $0x7c,%eax
80103df3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103df8:	74 36                	je     80103e30 <kill+0x60>
    if(p->pid == pid){
80103dfa:	39 58 10             	cmp    %ebx,0x10(%eax)
80103dfd:	75 f1                	jne    80103df0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103dff:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e03:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e0a:	74 14                	je     80103e20 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e13:	e8 f8 03 00 00       	call   80104210 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e18:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e1b:	31 c0                	xor    %eax,%eax
}
80103e1d:	5b                   	pop    %ebx
80103e1e:	5d                   	pop    %ebp
80103e1f:	c3                   	ret    
        p->state = RUNNABLE;
80103e20:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e27:	eb e3                	jmp    80103e0c <kill+0x3c>
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e30:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e37:	e8 d4 03 00 00       	call   80104210 <release>
}
80103e3c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e44:	5b                   	pop    %ebx
80103e45:	5d                   	pop    %ebp
80103e46:	c3                   	ret    
80103e47:	89 f6                	mov    %esi,%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e5b:	83 ec 4c             	sub    $0x4c,%esp
80103e5e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e61:	eb 20                	jmp    80103e83 <procdump+0x33>
80103e63:	90                   	nop
80103e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e68:	c7 04 24 5f 76 10 80 	movl   $0x8010765f,(%esp)
80103e6f:	e8 dc c7 ff ff       	call   80100650 <cprintf>
80103e74:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e77:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103e7d:	0f 84 8d 00 00 00    	je     80103f10 <procdump+0xc0>
    if(p->state == UNUSED)
80103e83:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103e86:	85 c0                	test   %eax,%eax
80103e88:	74 ea                	je     80103e74 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e8a:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103e8d:	ba e0 72 10 80       	mov    $0x801072e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e92:	77 11                	ja     80103ea5 <procdump+0x55>
80103e94:	8b 14 85 40 73 10 80 	mov    -0x7fef8cc0(,%eax,4),%edx
      state = "???";
80103e9b:	b8 e0 72 10 80       	mov    $0x801072e0,%eax
80103ea0:	85 d2                	test   %edx,%edx
80103ea2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ea5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ea8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103eac:	89 54 24 08          	mov    %edx,0x8(%esp)
80103eb0:	c7 04 24 e4 72 10 80 	movl   $0x801072e4,(%esp)
80103eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ebb:	e8 90 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103ec0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ec4:	75 a2                	jne    80103e68 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ec6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ecd:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ed0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ed3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ed6:	83 c0 08             	add    $0x8,%eax
80103ed9:	89 04 24             	mov    %eax,(%esp)
80103edc:	e8 6f 01 00 00       	call   80104050 <getcallerpcs>
80103ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ee8:	8b 17                	mov    (%edi),%edx
80103eea:	85 d2                	test   %edx,%edx
80103eec:	0f 84 76 ff ff ff    	je     80103e68 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103ef2:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ef6:	83 c7 04             	add    $0x4,%edi
80103ef9:	c7 04 24 21 6d 10 80 	movl   $0x80106d21,(%esp)
80103f00:	e8 4b c7 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f05:	39 f7                	cmp    %esi,%edi
80103f07:	75 df                	jne    80103ee8 <procdump+0x98>
80103f09:	e9 5a ff ff ff       	jmp    80103e68 <procdump+0x18>
80103f0e:	66 90                	xchg   %ax,%ax
  }
}
80103f10:	83 c4 4c             	add    $0x4c,%esp
80103f13:	5b                   	pop    %ebx
80103f14:	5e                   	pop    %esi
80103f15:	5f                   	pop    %edi
80103f16:	5d                   	pop    %ebp
80103f17:	c3                   	ret    
80103f18:	66 90                	xchg   %ax,%ax
80103f1a:	66 90                	xchg   %ax,%ax
80103f1c:	66 90                	xchg   %ax,%ax
80103f1e:	66 90                	xchg   %ax,%ax

80103f20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 14             	sub    $0x14,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f2a:	c7 44 24 04 58 73 10 	movl   $0x80107358,0x4(%esp)
80103f31:	80 
80103f32:	8d 43 04             	lea    0x4(%ebx),%eax
80103f35:	89 04 24             	mov    %eax,(%esp)
80103f38:	e8 f3 00 00 00       	call   80104030 <initlock>
  lk->name = name;
80103f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f40:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f46:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f4d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f50:	83 c4 14             	add    $0x14,%esp
80103f53:	5b                   	pop    %ebx
80103f54:	5d                   	pop    %ebp
80103f55:	c3                   	ret    
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
80103f65:	83 ec 10             	sub    $0x10,%esp
80103f68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f6b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f6e:	89 34 24             	mov    %esi,(%esp)
80103f71:	e8 aa 01 00 00       	call   80104120 <acquire>
  while (lk->locked) {
80103f76:	8b 13                	mov    (%ebx),%edx
80103f78:	85 d2                	test   %edx,%edx
80103f7a:	74 16                	je     80103f92 <acquiresleep+0x32>
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103f80:	89 74 24 04          	mov    %esi,0x4(%esp)
80103f84:	89 1c 24             	mov    %ebx,(%esp)
80103f87:	e8 54 fc ff ff       	call   80103be0 <sleep>
  while (lk->locked) {
80103f8c:	8b 03                	mov    (%ebx),%eax
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	75 ee                	jne    80103f80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103f92:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103f98:	e8 e3 f6 ff ff       	call   80103680 <myproc>
80103f9d:	8b 40 10             	mov    0x10(%eax),%eax
80103fa0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fa3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fa6:	83 c4 10             	add    $0x10,%esp
80103fa9:	5b                   	pop    %ebx
80103faa:	5e                   	pop    %esi
80103fab:	5d                   	pop    %ebp
  release(&lk->lk);
80103fac:	e9 5f 02 00 00       	jmp    80104210 <release>
80103fb1:	eb 0d                	jmp    80103fc0 <releasesleep>
80103fb3:	90                   	nop
80103fb4:	90                   	nop
80103fb5:	90                   	nop
80103fb6:	90                   	nop
80103fb7:	90                   	nop
80103fb8:	90                   	nop
80103fb9:	90                   	nop
80103fba:	90                   	nop
80103fbb:	90                   	nop
80103fbc:	90                   	nop
80103fbd:	90                   	nop
80103fbe:	90                   	nop
80103fbf:	90                   	nop

80103fc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
80103fc5:	83 ec 10             	sub    $0x10,%esp
80103fc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fcb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fce:	89 34 24             	mov    %esi,(%esp)
80103fd1:	e8 4a 01 00 00       	call   80104120 <acquire>
  lk->locked = 0;
80103fd6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fdc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103fe3:	89 1c 24             	mov    %ebx,(%esp)
80103fe6:	e8 85 fd ff ff       	call   80103d70 <wakeup>
  release(&lk->lk);
80103feb:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fee:	83 c4 10             	add    $0x10,%esp
80103ff1:	5b                   	pop    %ebx
80103ff2:	5e                   	pop    %esi
80103ff3:	5d                   	pop    %ebp
  release(&lk->lk);
80103ff4:	e9 17 02 00 00       	jmp    80104210 <release>
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104000 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	83 ec 10             	sub    $0x10,%esp
80104008:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010400b:	8d 73 04             	lea    0x4(%ebx),%esi
8010400e:	89 34 24             	mov    %esi,(%esp)
80104011:	e8 0a 01 00 00       	call   80104120 <acquire>
  r = lk->locked;
80104016:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104018:	89 34 24             	mov    %esi,(%esp)
8010401b:	e8 f0 01 00 00       	call   80104210 <release>
  return r;
}
80104020:	83 c4 10             	add    $0x10,%esp
80104023:	89 d8                	mov    %ebx,%eax
80104025:	5b                   	pop    %ebx
80104026:	5e                   	pop    %esi
80104027:	5d                   	pop    %ebp
80104028:	c3                   	ret    
80104029:	66 90                	xchg   %ax,%ax
8010402b:	66 90                	xchg   %ax,%ax
8010402d:	66 90                	xchg   %ax,%ax
8010402f:	90                   	nop

80104030 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104036:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010403f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104042:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104049:	5d                   	pop    %ebp
8010404a:	c3                   	ret    
8010404b:	90                   	nop
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104050 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104053:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104059:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010405a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010405d:	31 c0                	xor    %eax,%eax
8010405f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104060:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104066:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010406c:	77 1a                	ja     80104088 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010406e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104071:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104074:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104077:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104079:	83 f8 0a             	cmp    $0xa,%eax
8010407c:	75 e2                	jne    80104060 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010407e:	5b                   	pop    %ebx
8010407f:	5d                   	pop    %ebp
80104080:	c3                   	ret    
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104088:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010408f:	83 c0 01             	add    $0x1,%eax
80104092:	83 f8 0a             	cmp    $0xa,%eax
80104095:	74 e7                	je     8010407e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104097:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010409e:	83 c0 01             	add    $0x1,%eax
801040a1:	83 f8 0a             	cmp    $0xa,%eax
801040a4:	75 e2                	jne    80104088 <getcallerpcs+0x38>
801040a6:	eb d6                	jmp    8010407e <getcallerpcs+0x2e>
801040a8:	90                   	nop
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040b0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040b0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040b1:	31 c0                	xor    %eax,%eax
{
801040b3:	89 e5                	mov    %esp,%ebp
801040b5:	53                   	push   %ebx
801040b6:	83 ec 04             	sub    $0x4,%esp
801040b9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040bc:	8b 0a                	mov    (%edx),%ecx
801040be:	85 c9                	test   %ecx,%ecx
801040c0:	74 10                	je     801040d2 <holding+0x22>
801040c2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040c5:	e8 16 f5 ff ff       	call   801035e0 <mycpu>
801040ca:	39 c3                	cmp    %eax,%ebx
801040cc:	0f 94 c0             	sete   %al
801040cf:	0f b6 c0             	movzbl %al,%eax
}
801040d2:	83 c4 04             	add    $0x4,%esp
801040d5:	5b                   	pop    %ebx
801040d6:	5d                   	pop    %ebp
801040d7:	c3                   	ret    
801040d8:	90                   	nop
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 04             	sub    $0x4,%esp
801040e7:	9c                   	pushf  
801040e8:	5b                   	pop    %ebx
  asm volatile("cli");
801040e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801040ea:	e8 f1 f4 ff ff       	call   801035e0 <mycpu>
801040ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801040f5:	85 c0                	test   %eax,%eax
801040f7:	75 11                	jne    8010410a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801040f9:	e8 e2 f4 ff ff       	call   801035e0 <mycpu>
801040fe:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104104:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010410a:	e8 d1 f4 ff ff       	call   801035e0 <mycpu>
8010410f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104116:	83 c4 04             	add    $0x4,%esp
80104119:	5b                   	pop    %ebx
8010411a:	5d                   	pop    %ebp
8010411b:	c3                   	ret    
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104120 <acquire>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104127:	e8 b4 ff ff ff       	call   801040e0 <pushcli>
  if(holding(lk))
8010412c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010412f:	8b 02                	mov    (%edx),%eax
80104131:	85 c0                	test   %eax,%eax
80104133:	75 43                	jne    80104178 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104135:	b9 01 00 00 00       	mov    $0x1,%ecx
8010413a:	eb 07                	jmp    80104143 <acquire+0x23>
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104140:	8b 55 08             	mov    0x8(%ebp),%edx
80104143:	89 c8                	mov    %ecx,%eax
80104145:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104148:	85 c0                	test   %eax,%eax
8010414a:	75 f4                	jne    80104140 <acquire+0x20>
  __sync_synchronize();
8010414c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010414f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104152:	e8 89 f4 ff ff       	call   801035e0 <mycpu>
80104157:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010415a:	8b 45 08             	mov    0x8(%ebp),%eax
8010415d:	83 c0 0c             	add    $0xc,%eax
80104160:	89 44 24 04          	mov    %eax,0x4(%esp)
80104164:	8d 45 08             	lea    0x8(%ebp),%eax
80104167:	89 04 24             	mov    %eax,(%esp)
8010416a:	e8 e1 fe ff ff       	call   80104050 <getcallerpcs>
}
8010416f:	83 c4 14             	add    $0x14,%esp
80104172:	5b                   	pop    %ebx
80104173:	5d                   	pop    %ebp
80104174:	c3                   	ret    
80104175:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104178:	8b 5a 08             	mov    0x8(%edx),%ebx
8010417b:	e8 60 f4 ff ff       	call   801035e0 <mycpu>
  if(holding(lk))
80104180:	39 c3                	cmp    %eax,%ebx
80104182:	74 05                	je     80104189 <acquire+0x69>
80104184:	8b 55 08             	mov    0x8(%ebp),%edx
80104187:	eb ac                	jmp    80104135 <acquire+0x15>
    panic("acquire");
80104189:	c7 04 24 63 73 10 80 	movl   $0x80107363,(%esp)
80104190:	e8 cb c1 ff ff       	call   80100360 <panic>
80104195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <popcli>:

void
popcli(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041a6:	9c                   	pushf  
801041a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041a8:	f6 c4 02             	test   $0x2,%ah
801041ab:	75 49                	jne    801041f6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ad:	e8 2e f4 ff ff       	call   801035e0 <mycpu>
801041b2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041b8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041bb:	85 d2                	test   %edx,%edx
801041bd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041c3:	78 25                	js     801041ea <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041c5:	e8 16 f4 ff ff       	call   801035e0 <mycpu>
801041ca:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041d0:	85 d2                	test   %edx,%edx
801041d2:	74 04                	je     801041d8 <popcli+0x38>
    sti();
}
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041d8:	e8 03 f4 ff ff       	call   801035e0 <mycpu>
801041dd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041e3:	85 c0                	test   %eax,%eax
801041e5:	74 ed                	je     801041d4 <popcli+0x34>
  asm volatile("sti");
801041e7:	fb                   	sti    
}
801041e8:	c9                   	leave  
801041e9:	c3                   	ret    
    panic("popcli");
801041ea:	c7 04 24 82 73 10 80 	movl   $0x80107382,(%esp)
801041f1:	e8 6a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
801041f6:	c7 04 24 6b 73 10 80 	movl   $0x8010736b,(%esp)
801041fd:	e8 5e c1 ff ff       	call   80100360 <panic>
80104202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <release>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	83 ec 10             	sub    $0x10,%esp
80104218:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010421b:	8b 03                	mov    (%ebx),%eax
8010421d:	85 c0                	test   %eax,%eax
8010421f:	75 0f                	jne    80104230 <release+0x20>
    panic("release");
80104221:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
80104228:	e8 33 c1 ff ff       	call   80100360 <panic>
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104230:	8b 73 08             	mov    0x8(%ebx),%esi
80104233:	e8 a8 f3 ff ff       	call   801035e0 <mycpu>
  if(!holding(lk))
80104238:	39 c6                	cmp    %eax,%esi
8010423a:	75 e5                	jne    80104221 <release+0x11>
  lk->pcs[0] = 0;
8010423c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104243:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010424a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010424d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104253:	83 c4 10             	add    $0x10,%esp
80104256:	5b                   	pop    %ebx
80104257:	5e                   	pop    %esi
80104258:	5d                   	pop    %ebp
  popcli();
80104259:	e9 42 ff ff ff       	jmp    801041a0 <popcli>
8010425e:	66 90                	xchg   %ax,%ax

80104260 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	8b 55 08             	mov    0x8(%ebp),%edx
80104266:	57                   	push   %edi
80104267:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010426a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010426b:	f6 c2 03             	test   $0x3,%dl
8010426e:	75 05                	jne    80104275 <memset+0x15>
80104270:	f6 c1 03             	test   $0x3,%cl
80104273:	74 13                	je     80104288 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104275:	89 d7                	mov    %edx,%edi
80104277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427a:	fc                   	cld    
8010427b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010427d:	5b                   	pop    %ebx
8010427e:	89 d0                	mov    %edx,%eax
80104280:	5f                   	pop    %edi
80104281:	5d                   	pop    %ebp
80104282:	c3                   	ret    
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104288:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010428c:	c1 e9 02             	shr    $0x2,%ecx
8010428f:	89 f8                	mov    %edi,%eax
80104291:	89 fb                	mov    %edi,%ebx
80104293:	c1 e0 18             	shl    $0x18,%eax
80104296:	c1 e3 10             	shl    $0x10,%ebx
80104299:	09 d8                	or     %ebx,%eax
8010429b:	09 f8                	or     %edi,%eax
8010429d:	c1 e7 08             	shl    $0x8,%edi
801042a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042a2:	89 d7                	mov    %edx,%edi
801042a4:	fc                   	cld    
801042a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042a7:	5b                   	pop    %ebx
801042a8:	89 d0                	mov    %edx,%eax
801042aa:	5f                   	pop    %edi
801042ab:	5d                   	pop    %ebp
801042ac:	c3                   	ret    
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

801042b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	8b 45 10             	mov    0x10(%ebp),%eax
801042b6:	57                   	push   %edi
801042b7:	56                   	push   %esi
801042b8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042bb:	53                   	push   %ebx
801042bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042bf:	85 c0                	test   %eax,%eax
801042c1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042c4:	74 26                	je     801042ec <memcmp+0x3c>
    if(*s1 != *s2)
801042c6:	0f b6 03             	movzbl (%ebx),%eax
801042c9:	31 d2                	xor    %edx,%edx
801042cb:	0f b6 0e             	movzbl (%esi),%ecx
801042ce:	38 c8                	cmp    %cl,%al
801042d0:	74 16                	je     801042e8 <memcmp+0x38>
801042d2:	eb 24                	jmp    801042f8 <memcmp+0x48>
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042dd:	83 c2 01             	add    $0x1,%edx
801042e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801042e4:	38 c8                	cmp    %cl,%al
801042e6:	75 10                	jne    801042f8 <memcmp+0x48>
  while(n-- > 0){
801042e8:	39 fa                	cmp    %edi,%edx
801042ea:	75 ec                	jne    801042d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801042ec:	5b                   	pop    %ebx
  return 0;
801042ed:	31 c0                	xor    %eax,%eax
}
801042ef:	5e                   	pop    %esi
801042f0:	5f                   	pop    %edi
801042f1:	5d                   	pop    %ebp
801042f2:	c3                   	ret    
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f8:	5b                   	pop    %ebx
      return *s1 - *s2;
801042f9:	29 c8                	sub    %ecx,%eax
}
801042fb:	5e                   	pop    %esi
801042fc:	5f                   	pop    %edi
801042fd:	5d                   	pop    %ebp
801042fe:	c3                   	ret    
801042ff:	90                   	nop

80104300 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	8b 45 08             	mov    0x8(%ebp),%eax
80104307:	56                   	push   %esi
80104308:	8b 75 0c             	mov    0xc(%ebp),%esi
8010430b:	53                   	push   %ebx
8010430c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010430f:	39 c6                	cmp    %eax,%esi
80104311:	73 35                	jae    80104348 <memmove+0x48>
80104313:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104316:	39 c8                	cmp    %ecx,%eax
80104318:	73 2e                	jae    80104348 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010431a:	85 db                	test   %ebx,%ebx
    d += n;
8010431c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010431f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104322:	74 1b                	je     8010433f <memmove+0x3f>
80104324:	f7 db                	neg    %ebx
80104326:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104329:	01 fb                	add    %edi,%ebx
8010432b:	90                   	nop
8010432c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104330:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104334:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104337:	83 ea 01             	sub    $0x1,%edx
8010433a:	83 fa ff             	cmp    $0xffffffff,%edx
8010433d:	75 f1                	jne    80104330 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010433f:	5b                   	pop    %ebx
80104340:	5e                   	pop    %esi
80104341:	5f                   	pop    %edi
80104342:	5d                   	pop    %ebp
80104343:	c3                   	ret    
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104348:	31 d2                	xor    %edx,%edx
8010434a:	85 db                	test   %ebx,%ebx
8010434c:	74 f1                	je     8010433f <memmove+0x3f>
8010434e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104350:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104354:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104357:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010435a:	39 da                	cmp    %ebx,%edx
8010435c:	75 f2                	jne    80104350 <memmove+0x50>
}
8010435e:	5b                   	pop    %ebx
8010435f:	5e                   	pop    %esi
80104360:	5f                   	pop    %edi
80104361:	5d                   	pop    %ebp
80104362:	c3                   	ret    
80104363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104373:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104374:	eb 8a                	jmp    80104300 <memmove>
80104376:	8d 76 00             	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	8b 75 10             	mov    0x10(%ebp),%esi
80104387:	53                   	push   %ebx
80104388:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010438b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010438e:	85 f6                	test   %esi,%esi
80104390:	74 30                	je     801043c2 <strncmp+0x42>
80104392:	0f b6 01             	movzbl (%ecx),%eax
80104395:	84 c0                	test   %al,%al
80104397:	74 2f                	je     801043c8 <strncmp+0x48>
80104399:	0f b6 13             	movzbl (%ebx),%edx
8010439c:	38 d0                	cmp    %dl,%al
8010439e:	75 46                	jne    801043e6 <strncmp+0x66>
801043a0:	8d 51 01             	lea    0x1(%ecx),%edx
801043a3:	01 ce                	add    %ecx,%esi
801043a5:	eb 14                	jmp    801043bb <strncmp+0x3b>
801043a7:	90                   	nop
801043a8:	0f b6 02             	movzbl (%edx),%eax
801043ab:	84 c0                	test   %al,%al
801043ad:	74 31                	je     801043e0 <strncmp+0x60>
801043af:	0f b6 19             	movzbl (%ecx),%ebx
801043b2:	83 c2 01             	add    $0x1,%edx
801043b5:	38 d8                	cmp    %bl,%al
801043b7:	75 17                	jne    801043d0 <strncmp+0x50>
    n--, p++, q++;
801043b9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801043bb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043bd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801043c0:	75 e6                	jne    801043a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801043c2:	5b                   	pop    %ebx
    return 0;
801043c3:	31 c0                	xor    %eax,%eax
}
801043c5:	5e                   	pop    %esi
801043c6:	5d                   	pop    %ebp
801043c7:	c3                   	ret    
801043c8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801043cb:	31 c0                	xor    %eax,%eax
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801043d0:	0f b6 d3             	movzbl %bl,%edx
801043d3:	29 d0                	sub    %edx,%eax
}
801043d5:	5b                   	pop    %ebx
801043d6:	5e                   	pop    %esi
801043d7:	5d                   	pop    %ebp
801043d8:	c3                   	ret    
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801043e4:	eb ea                	jmp    801043d0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801043e6:	89 d3                	mov    %edx,%ebx
801043e8:	eb e6                	jmp    801043d0 <strncmp+0x50>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 08             	mov    0x8(%ebp),%eax
801043f6:	56                   	push   %esi
801043f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043fa:	53                   	push   %ebx
801043fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801043fe:	89 c2                	mov    %eax,%edx
80104400:	eb 19                	jmp    8010441b <strncpy+0x2b>
80104402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104408:	83 c3 01             	add    $0x1,%ebx
8010440b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010440f:	83 c2 01             	add    $0x1,%edx
80104412:	84 c9                	test   %cl,%cl
80104414:	88 4a ff             	mov    %cl,-0x1(%edx)
80104417:	74 09                	je     80104422 <strncpy+0x32>
80104419:	89 f1                	mov    %esi,%ecx
8010441b:	85 c9                	test   %ecx,%ecx
8010441d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104420:	7f e6                	jg     80104408 <strncpy+0x18>
    ;
  while(n-- > 0)
80104422:	31 c9                	xor    %ecx,%ecx
80104424:	85 f6                	test   %esi,%esi
80104426:	7e 0f                	jle    80104437 <strncpy+0x47>
    *s++ = 0;
80104428:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010442c:	89 f3                	mov    %esi,%ebx
8010442e:	83 c1 01             	add    $0x1,%ecx
80104431:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104433:	85 db                	test   %ebx,%ebx
80104435:	7f f1                	jg     80104428 <strncpy+0x38>
  return os;
}
80104437:	5b                   	pop    %ebx
80104438:	5e                   	pop    %esi
80104439:	5d                   	pop    %ebp
8010443a:	c3                   	ret    
8010443b:	90                   	nop
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104440 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104446:	56                   	push   %esi
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
8010444a:	53                   	push   %ebx
8010444b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010444e:	85 c9                	test   %ecx,%ecx
80104450:	7e 26                	jle    80104478 <safestrcpy+0x38>
80104452:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104456:	89 c1                	mov    %eax,%ecx
80104458:	eb 17                	jmp    80104471 <safestrcpy+0x31>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104460:	83 c2 01             	add    $0x1,%edx
80104463:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104467:	83 c1 01             	add    $0x1,%ecx
8010446a:	84 db                	test   %bl,%bl
8010446c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010446f:	74 04                	je     80104475 <safestrcpy+0x35>
80104471:	39 f2                	cmp    %esi,%edx
80104473:	75 eb                	jne    80104460 <safestrcpy+0x20>
    ;
  *s = 0;
80104475:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104478:	5b                   	pop    %ebx
80104479:	5e                   	pop    %esi
8010447a:	5d                   	pop    %ebp
8010447b:	c3                   	ret    
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <strlen>:

int
strlen(const char *s)
{
80104480:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104481:	31 c0                	xor    %eax,%eax
{
80104483:	89 e5                	mov    %esp,%ebp
80104485:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104488:	80 3a 00             	cmpb   $0x0,(%edx)
8010448b:	74 0c                	je     80104499 <strlen+0x19>
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
80104490:	83 c0 01             	add    $0x1,%eax
80104493:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104497:	75 f7                	jne    80104490 <strlen+0x10>
    ;
  return n;
}
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret    

8010449b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010449b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010449f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044a3:	55                   	push   %ebp
  pushl %ebx
801044a4:	53                   	push   %ebx
  pushl %esi
801044a5:	56                   	push   %esi
  pushl %edi
801044a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044a9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044ab:	5f                   	pop    %edi
  popl %esi
801044ac:	5e                   	pop    %esi
  popl %ebx
801044ad:	5b                   	pop    %ebx
  popl %ebp
801044ae:	5d                   	pop    %ebp
  ret
801044af:	c3                   	ret    

801044b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 04             	sub    $0x4,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801044ba:	e8 c1 f1 ff ff       	call   80103680 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801044bf:	8b 00                	mov    (%eax),%eax
801044c1:	39 d8                	cmp    %ebx,%eax
801044c3:	76 1b                	jbe    801044e0 <fetchint+0x30>
801044c5:	8d 53 04             	lea    0x4(%ebx),%edx
801044c8:	39 d0                	cmp    %edx,%eax
801044ca:	72 14                	jb     801044e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801044cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801044cf:	8b 13                	mov    (%ebx),%edx
801044d1:	89 10                	mov    %edx,(%eax)
  return 0;
801044d3:	31 c0                	xor    %eax,%eax
}
801044d5:	83 c4 04             	add    $0x4,%esp
801044d8:	5b                   	pop    %ebx
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801044e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e5:	eb ee                	jmp    801044d5 <fetchint+0x25>
801044e7:	89 f6                	mov    %esi,%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 04             	sub    $0x4,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801044fa:	e8 81 f1 ff ff       	call   80103680 <myproc>

  if(addr >= curproc->sz)
801044ff:	39 18                	cmp    %ebx,(%eax)
80104501:	76 26                	jbe    80104529 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104506:	89 da                	mov    %ebx,%edx
80104508:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010450a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010450c:	39 c3                	cmp    %eax,%ebx
8010450e:	73 19                	jae    80104529 <fetchstr+0x39>
    if(*s == 0)
80104510:	80 3b 00             	cmpb   $0x0,(%ebx)
80104513:	75 0d                	jne    80104522 <fetchstr+0x32>
80104515:	eb 21                	jmp    80104538 <fetchstr+0x48>
80104517:	90                   	nop
80104518:	80 3a 00             	cmpb   $0x0,(%edx)
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104520:	74 16                	je     80104538 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104522:	83 c2 01             	add    $0x1,%edx
80104525:	39 d0                	cmp    %edx,%eax
80104527:	77 ef                	ja     80104518 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104529:	83 c4 04             	add    $0x4,%esp
    return -1;
8010452c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104531:	5b                   	pop    %ebx
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010453b:	89 d0                	mov    %edx,%eax
8010453d:	29 d8                	sub    %ebx,%eax
}
8010453f:	5b                   	pop    %ebx
80104540:	5d                   	pop    %ebp
80104541:	c3                   	ret    
80104542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	8b 75 0c             	mov    0xc(%ebp),%esi
80104557:	53                   	push   %ebx
80104558:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010455b:	e8 20 f1 ff ff       	call   80103680 <myproc>
80104560:	89 75 0c             	mov    %esi,0xc(%ebp)
80104563:	8b 40 18             	mov    0x18(%eax),%eax
80104566:	8b 40 44             	mov    0x44(%eax),%eax
80104569:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010456d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104570:	5b                   	pop    %ebx
80104571:	5e                   	pop    %esi
80104572:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104573:	e9 38 ff ff ff       	jmp    801044b0 <fetchint>
80104578:	90                   	nop
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	83 ec 20             	sub    $0x20,%esp
80104588:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010458b:	e8 f0 f0 ff ff       	call   80103680 <myproc>
80104590:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104592:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104595:	89 44 24 04          	mov    %eax,0x4(%esp)
80104599:	8b 45 08             	mov    0x8(%ebp),%eax
8010459c:	89 04 24             	mov    %eax,(%esp)
8010459f:	e8 ac ff ff ff       	call   80104550 <argint>
801045a4:	85 c0                	test   %eax,%eax
801045a6:	78 28                	js     801045d0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801045a8:	85 db                	test   %ebx,%ebx
801045aa:	78 24                	js     801045d0 <argptr+0x50>
801045ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045af:	8b 06                	mov    (%esi),%eax
801045b1:	39 c2                	cmp    %eax,%edx
801045b3:	73 1b                	jae    801045d0 <argptr+0x50>
801045b5:	01 d3                	add    %edx,%ebx
801045b7:	39 d8                	cmp    %ebx,%eax
801045b9:	72 15                	jb     801045d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801045bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801045be:	89 10                	mov    %edx,(%eax)
  return 0;
}
801045c0:	83 c4 20             	add    $0x20,%esp
  return 0;
801045c3:	31 c0                	xor    %eax,%eax
}
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
801045c8:	c3                   	ret    
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d0:	83 c4 20             	add    $0x20,%esp
    return -1;
801045d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045d8:	5b                   	pop    %ebx
801045d9:	5e                   	pop    %esi
801045da:	5d                   	pop    %ebp
801045db:	c3                   	ret    
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801045e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801045ed:	8b 45 08             	mov    0x8(%ebp),%eax
801045f0:	89 04 24             	mov    %eax,(%esp)
801045f3:	e8 58 ff ff ff       	call   80104550 <argint>
801045f8:	85 c0                	test   %eax,%eax
801045fa:	78 14                	js     80104610 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801045fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801045ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104606:	89 04 24             	mov    %eax,(%esp)
80104609:	e8 e2 fe ff ff       	call   801044f0 <fetchstr>
}
8010460e:	c9                   	leave  
8010460f:	c3                   	ret    
    return -1;
80104610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104615:	c9                   	leave  
80104616:	c3                   	ret    
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104628:	e8 53 f0 ff ff       	call   80103680 <myproc>

  num = curproc->tf->eax;
8010462d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104630:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104632:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104635:	8d 50 ff             	lea    -0x1(%eax),%edx
80104638:	83 fa 16             	cmp    $0x16,%edx
8010463b:	77 1b                	ja     80104658 <syscall+0x38>
8010463d:	8b 14 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%edx
80104644:	85 d2                	test   %edx,%edx
80104646:	74 10                	je     80104658 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104648:	ff d2                	call   *%edx
8010464a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010464d:	83 c4 10             	add    $0x10,%esp
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104658:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010465c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010465f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104663:	8b 43 10             	mov    0x10(%ebx),%eax
80104666:	c7 04 24 91 73 10 80 	movl   $0x80107391,(%esp)
8010466d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104671:	e8 da bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104676:	8b 43 18             	mov    0x18(%ebx),%eax
80104679:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104680:	83 c4 10             	add    $0x10,%esp
80104683:	5b                   	pop    %ebx
80104684:	5e                   	pop    %esi
80104685:	5d                   	pop    %ebp
80104686:	c3                   	ret    
80104687:	66 90                	xchg   %ax,%ax
80104689:	66 90                	xchg   %ax,%ax
8010468b:	66 90                	xchg   %ax,%ax
8010468d:	66 90                	xchg   %ax,%ax
8010468f:	90                   	nop

80104690 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	89 c3                	mov    %eax,%ebx
80104696:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104699:	e8 e2 ef ff ff       	call   80103680 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010469e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801046a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801046a4:	85 c9                	test   %ecx,%ecx
801046a6:	74 18                	je     801046c0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
801046a8:	83 c2 01             	add    $0x1,%edx
801046ab:	83 fa 10             	cmp    $0x10,%edx
801046ae:	75 f0                	jne    801046a0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046b0:	83 c4 04             	add    $0x4,%esp
  return -1;
801046b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046b8:	5b                   	pop    %ebx
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret    
801046bb:	90                   	nop
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801046c0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801046c4:	83 c4 04             	add    $0x4,%esp
      return fd;
801046c7:	89 d0                	mov    %edx,%eax
}
801046c9:	5b                   	pop    %ebx
801046ca:	5d                   	pop    %ebp
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	53                   	push   %ebx
801046d6:	83 ec 4c             	sub    $0x4c,%esp
801046d9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046df:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046e6:	89 04 24             	mov    %eax,(%esp)
{
801046e9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801046ec:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801046ef:	e8 0c d8 ff ff       	call   80101f00 <nameiparent>
801046f4:	85 c0                	test   %eax,%eax
801046f6:	89 c7                	mov    %eax,%edi
801046f8:	0f 84 da 00 00 00    	je     801047d8 <create+0x108>
    return 0;
  ilock(dp);
801046fe:	89 04 24             	mov    %eax,(%esp)
80104701:	e8 8a cf ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104706:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104709:	89 44 24 08          	mov    %eax,0x8(%esp)
8010470d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104711:	89 3c 24             	mov    %edi,(%esp)
80104714:	e8 87 d4 ff ff       	call   80101ba0 <dirlookup>
80104719:	85 c0                	test   %eax,%eax
8010471b:	89 c6                	mov    %eax,%esi
8010471d:	74 41                	je     80104760 <create+0x90>
    iunlockput(dp);
8010471f:	89 3c 24             	mov    %edi,(%esp)
80104722:	e8 c9 d1 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104727:	89 34 24             	mov    %esi,(%esp)
8010472a:	e8 61 cf ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010472f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104734:	75 12                	jne    80104748 <create+0x78>
80104736:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010473b:	89 f0                	mov    %esi,%eax
8010473d:	75 09                	jne    80104748 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010473f:	83 c4 4c             	add    $0x4c,%esp
80104742:	5b                   	pop    %ebx
80104743:	5e                   	pop    %esi
80104744:	5f                   	pop    %edi
80104745:	5d                   	pop    %ebp
80104746:	c3                   	ret    
80104747:	90                   	nop
    iunlockput(ip);
80104748:	89 34 24             	mov    %esi,(%esp)
8010474b:	e8 a0 d1 ff ff       	call   801018f0 <iunlockput>
}
80104750:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104753:	31 c0                	xor    %eax,%eax
}
80104755:	5b                   	pop    %ebx
80104756:	5e                   	pop    %esi
80104757:	5f                   	pop    %edi
80104758:	5d                   	pop    %ebp
80104759:	c3                   	ret    
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104760:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104764:	89 44 24 04          	mov    %eax,0x4(%esp)
80104768:	8b 07                	mov    (%edi),%eax
8010476a:	89 04 24             	mov    %eax,(%esp)
8010476d:	e8 8e cd ff ff       	call   80101500 <ialloc>
80104772:	85 c0                	test   %eax,%eax
80104774:	89 c6                	mov    %eax,%esi
80104776:	0f 84 bf 00 00 00    	je     8010483b <create+0x16b>
  ilock(ip);
8010477c:	89 04 24             	mov    %eax,(%esp)
8010477f:	e8 0c cf ff ff       	call   80101690 <ilock>
  ip->major = major;
80104784:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104788:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010478c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104790:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104794:	b8 01 00 00 00       	mov    $0x1,%eax
80104799:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010479d:	89 34 24             	mov    %esi,(%esp)
801047a0:	e8 2b ce ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801047a5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047aa:	74 34                	je     801047e0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801047ac:	8b 46 04             	mov    0x4(%esi),%eax
801047af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047b3:	89 3c 24             	mov    %edi,(%esp)
801047b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ba:	e8 41 d6 ff ff       	call   80101e00 <dirlink>
801047bf:	85 c0                	test   %eax,%eax
801047c1:	78 6c                	js     8010482f <create+0x15f>
  iunlockput(dp);
801047c3:	89 3c 24             	mov    %edi,(%esp)
801047c6:	e8 25 d1 ff ff       	call   801018f0 <iunlockput>
}
801047cb:	83 c4 4c             	add    $0x4c,%esp
  return ip;
801047ce:	89 f0                	mov    %esi,%eax
}
801047d0:	5b                   	pop    %ebx
801047d1:	5e                   	pop    %esi
801047d2:	5f                   	pop    %edi
801047d3:	5d                   	pop    %ebp
801047d4:	c3                   	ret    
801047d5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801047d8:	31 c0                	xor    %eax,%eax
801047da:	e9 60 ff ff ff       	jmp    8010473f <create+0x6f>
801047df:	90                   	nop
    dp->nlink++;  // for ".."
801047e0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047e5:	89 3c 24             	mov    %edi,(%esp)
801047e8:	e8 e3 cd ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047ed:	8b 46 04             	mov    0x4(%esi),%eax
801047f0:	c7 44 24 04 3c 74 10 	movl   $0x8010743c,0x4(%esp)
801047f7:	80 
801047f8:	89 34 24             	mov    %esi,(%esp)
801047fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ff:	e8 fc d5 ff ff       	call   80101e00 <dirlink>
80104804:	85 c0                	test   %eax,%eax
80104806:	78 1b                	js     80104823 <create+0x153>
80104808:	8b 47 04             	mov    0x4(%edi),%eax
8010480b:	c7 44 24 04 3b 74 10 	movl   $0x8010743b,0x4(%esp)
80104812:	80 
80104813:	89 34 24             	mov    %esi,(%esp)
80104816:	89 44 24 08          	mov    %eax,0x8(%esp)
8010481a:	e8 e1 d5 ff ff       	call   80101e00 <dirlink>
8010481f:	85 c0                	test   %eax,%eax
80104821:	79 89                	jns    801047ac <create+0xdc>
      panic("create dots");
80104823:	c7 04 24 2f 74 10 80 	movl   $0x8010742f,(%esp)
8010482a:	e8 31 bb ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010482f:	c7 04 24 3e 74 10 80 	movl   $0x8010743e,(%esp)
80104836:	e8 25 bb ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010483b:	c7 04 24 20 74 10 80 	movl   $0x80107420,(%esp)
80104842:	e8 19 bb ff ff       	call   80100360 <panic>
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	89 c6                	mov    %eax,%esi
80104856:	53                   	push   %ebx
80104857:	89 d3                	mov    %edx,%ebx
80104859:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010485c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010485f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010486a:	e8 e1 fc ff ff       	call   80104550 <argint>
8010486f:	85 c0                	test   %eax,%eax
80104871:	78 2d                	js     801048a0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104873:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104877:	77 27                	ja     801048a0 <argfd.constprop.0+0x50>
80104879:	e8 02 ee ff ff       	call   80103680 <myproc>
8010487e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104881:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104885:	85 c0                	test   %eax,%eax
80104887:	74 17                	je     801048a0 <argfd.constprop.0+0x50>
  if(pfd)
80104889:	85 f6                	test   %esi,%esi
8010488b:	74 02                	je     8010488f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010488d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010488f:	85 db                	test   %ebx,%ebx
80104891:	74 1d                	je     801048b0 <argfd.constprop.0+0x60>
    *pf = f;
80104893:	89 03                	mov    %eax,(%ebx)
  return 0;
80104895:	31 c0                	xor    %eax,%eax
}
80104897:	83 c4 20             	add    $0x20,%esp
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret    
8010489e:	66 90                	xchg   %ax,%ax
801048a0:	83 c4 20             	add    $0x20,%esp
    return -1;
801048a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801048b0:	31 c0                	xor    %eax,%eax
801048b2:	eb e3                	jmp    80104897 <argfd.constprop.0+0x47>
801048b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048c0 <sys_dup>:
{
801048c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801048c1:	31 c0                	xor    %eax,%eax
{
801048c3:	89 e5                	mov    %esp,%ebp
801048c5:	53                   	push   %ebx
801048c6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801048c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048cc:	e8 7f ff ff ff       	call   80104850 <argfd.constprop.0>
801048d1:	85 c0                	test   %eax,%eax
801048d3:	78 23                	js     801048f8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801048d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d8:	e8 b3 fd ff ff       	call   80104690 <fdalloc>
801048dd:	85 c0                	test   %eax,%eax
801048df:	89 c3                	mov    %eax,%ebx
801048e1:	78 15                	js     801048f8 <sys_dup+0x38>
  filedup(f);
801048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e6:	89 04 24             	mov    %eax,(%esp)
801048e9:	e8 c2 c4 ff ff       	call   80100db0 <filedup>
  return fd;
801048ee:	89 d8                	mov    %ebx,%eax
}
801048f0:	83 c4 24             	add    $0x24,%esp
801048f3:	5b                   	pop    %ebx
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret    
801048f6:	66 90                	xchg   %ax,%ax
    return -1;
801048f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048fd:	eb f1                	jmp    801048f0 <sys_dup+0x30>
801048ff:	90                   	nop

80104900 <sys_read>:
{
80104900:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104901:	31 c0                	xor    %eax,%eax
{
80104903:	89 e5                	mov    %esp,%ebp
80104905:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104908:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010490b:	e8 40 ff ff ff       	call   80104850 <argfd.constprop.0>
80104910:	85 c0                	test   %eax,%eax
80104912:	78 54                	js     80104968 <sys_read+0x68>
80104914:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104917:	89 44 24 04          	mov    %eax,0x4(%esp)
8010491b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104922:	e8 29 fc ff ff       	call   80104550 <argint>
80104927:	85 c0                	test   %eax,%eax
80104929:	78 3d                	js     80104968 <sys_read+0x68>
8010492b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010492e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104935:	89 44 24 08          	mov    %eax,0x8(%esp)
80104939:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010493c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104940:	e8 3b fc ff ff       	call   80104580 <argptr>
80104945:	85 c0                	test   %eax,%eax
80104947:	78 1f                	js     80104968 <sys_read+0x68>
  return fileread(f, p, n);
80104949:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010494c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104953:	89 44 24 04          	mov    %eax,0x4(%esp)
80104957:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010495a:	89 04 24             	mov    %eax,(%esp)
8010495d:	e8 ae c5 ff ff       	call   80100f10 <fileread>
}
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010496d:	c9                   	leave  
8010496e:	c3                   	ret    
8010496f:	90                   	nop

80104970 <sys_write>:
{
80104970:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104971:	31 c0                	xor    %eax,%eax
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104978:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010497b:	e8 d0 fe ff ff       	call   80104850 <argfd.constprop.0>
80104980:	85 c0                	test   %eax,%eax
80104982:	78 54                	js     801049d8 <sys_write+0x68>
80104984:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104987:	89 44 24 04          	mov    %eax,0x4(%esp)
8010498b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104992:	e8 b9 fb ff ff       	call   80104550 <argint>
80104997:	85 c0                	test   %eax,%eax
80104999:	78 3d                	js     801049d8 <sys_write+0x68>
8010499b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010499e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b0:	e8 cb fb ff ff       	call   80104580 <argptr>
801049b5:	85 c0                	test   %eax,%eax
801049b7:	78 1f                	js     801049d8 <sys_write+0x68>
  return filewrite(f, p, n);
801049b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ca:	89 04 24             	mov    %eax,(%esp)
801049cd:	e8 de c5 ff ff       	call   80100fb0 <filewrite>
}
801049d2:	c9                   	leave  
801049d3:	c3                   	ret    
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049dd:	c9                   	leave  
801049de:	c3                   	ret    
801049df:	90                   	nop

801049e0 <sys_close>:
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801049e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049ec:	e8 5f fe ff ff       	call   80104850 <argfd.constprop.0>
801049f1:	85 c0                	test   %eax,%eax
801049f3:	78 23                	js     80104a18 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801049f5:	e8 86 ec ff ff       	call   80103680 <myproc>
801049fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049fd:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a04:	00 
  fileclose(f);
80104a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a08:	89 04 24             	mov    %eax,(%esp)
80104a0b:	e8 f0 c3 ff ff       	call   80100e00 <fileclose>
  return 0;
80104a10:	31 c0                	xor    %eax,%eax
}
80104a12:	c9                   	leave  
80104a13:	c3                   	ret    
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a1d:	c9                   	leave  
80104a1e:	c3                   	ret    
80104a1f:	90                   	nop

80104a20 <sys_fstat>:
{
80104a20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a21:	31 c0                	xor    %eax,%eax
{
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a2b:	e8 20 fe ff ff       	call   80104850 <argfd.constprop.0>
80104a30:	85 c0                	test   %eax,%eax
80104a32:	78 34                	js     80104a68 <sys_fstat+0x48>
80104a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a37:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a3e:	00 
80104a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a4a:	e8 31 fb ff ff       	call   80104580 <argptr>
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	78 15                	js     80104a68 <sys_fstat+0x48>
  return filestat(f, st);
80104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a56:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a5d:	89 04 24             	mov    %eax,(%esp)
80104a60:	e8 5b c4 ff ff       	call   80100ec0 <filestat>
}
80104a65:	c9                   	leave  
80104a66:	c3                   	ret    
80104a67:	90                   	nop
    return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    
80104a6f:	90                   	nop

80104a70 <sys_link>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
80104a76:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a79:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a87:	e8 54 fb ff ff       	call   801045e0 <argstr>
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	0f 88 e6 00 00 00    	js     80104b7a <sys_link+0x10a>
80104a94:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aa2:	e8 39 fb ff ff       	call   801045e0 <argstr>
80104aa7:	85 c0                	test   %eax,%eax
80104aa9:	0f 88 cb 00 00 00    	js     80104b7a <sys_link+0x10a>
  begin_op();
80104aaf:	e8 3c e0 ff ff       	call   80102af0 <begin_op>
  if((ip = namei(old)) == 0){
80104ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ab7:	89 04 24             	mov    %eax,(%esp)
80104aba:	e8 21 d4 ff ff       	call   80101ee0 <namei>
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	89 c3                	mov    %eax,%ebx
80104ac3:	0f 84 ac 00 00 00    	je     80104b75 <sys_link+0x105>
  ilock(ip);
80104ac9:	89 04 24             	mov    %eax,(%esp)
80104acc:	e8 bf cb ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104ad1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ad6:	0f 84 91 00 00 00    	je     80104b6d <sys_link+0xfd>
  ip->nlink++;
80104adc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ae1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ae4:	89 1c 24             	mov    %ebx,(%esp)
80104ae7:	e8 e4 ca ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80104aec:	89 1c 24             	mov    %ebx,(%esp)
80104aef:	e8 7c cc ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104af4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104af7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104afb:	89 04 24             	mov    %eax,(%esp)
80104afe:	e8 fd d3 ff ff       	call   80101f00 <nameiparent>
80104b03:	85 c0                	test   %eax,%eax
80104b05:	89 c6                	mov    %eax,%esi
80104b07:	74 4f                	je     80104b58 <sys_link+0xe8>
  ilock(dp);
80104b09:	89 04 24             	mov    %eax,(%esp)
80104b0c:	e8 7f cb ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b11:	8b 03                	mov    (%ebx),%eax
80104b13:	39 06                	cmp    %eax,(%esi)
80104b15:	75 39                	jne    80104b50 <sys_link+0xe0>
80104b17:	8b 43 04             	mov    0x4(%ebx),%eax
80104b1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b1e:	89 34 24             	mov    %esi,(%esp)
80104b21:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b25:	e8 d6 d2 ff ff       	call   80101e00 <dirlink>
80104b2a:	85 c0                	test   %eax,%eax
80104b2c:	78 22                	js     80104b50 <sys_link+0xe0>
  iunlockput(dp);
80104b2e:	89 34 24             	mov    %esi,(%esp)
80104b31:	e8 ba cd ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104b36:	89 1c 24             	mov    %ebx,(%esp)
80104b39:	e8 72 cc ff ff       	call   801017b0 <iput>
  end_op();
80104b3e:	e8 1d e0 ff ff       	call   80102b60 <end_op>
}
80104b43:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b46:	31 c0                	xor    %eax,%eax
}
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5f                   	pop    %edi
80104b4b:	5d                   	pop    %ebp
80104b4c:	c3                   	ret    
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b50:	89 34 24             	mov    %esi,(%esp)
80104b53:	e8 98 cd ff ff       	call   801018f0 <iunlockput>
  ilock(ip);
80104b58:	89 1c 24             	mov    %ebx,(%esp)
80104b5b:	e8 30 cb ff ff       	call   80101690 <ilock>
  ip->nlink--;
80104b60:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b65:	89 1c 24             	mov    %ebx,(%esp)
80104b68:	e8 63 ca ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104b6d:	89 1c 24             	mov    %ebx,(%esp)
80104b70:	e8 7b cd ff ff       	call   801018f0 <iunlockput>
  end_op();
80104b75:	e8 e6 df ff ff       	call   80102b60 <end_op>
}
80104b7a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b82:	5b                   	pop    %ebx
80104b83:	5e                   	pop    %esi
80104b84:	5f                   	pop    %edi
80104b85:	5d                   	pop    %ebp
80104b86:	c3                   	ret    
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <sys_unlink>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	53                   	push   %ebx
80104b96:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104b99:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ba7:	e8 34 fa ff ff       	call   801045e0 <argstr>
80104bac:	85 c0                	test   %eax,%eax
80104bae:	0f 88 76 01 00 00    	js     80104d2a <sys_unlink+0x19a>
  begin_op();
80104bb4:	e8 37 df ff ff       	call   80102af0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104bb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bbc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104bbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bc3:	89 04 24             	mov    %eax,(%esp)
80104bc6:	e8 35 d3 ff ff       	call   80101f00 <nameiparent>
80104bcb:	85 c0                	test   %eax,%eax
80104bcd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bd0:	0f 84 4f 01 00 00    	je     80104d25 <sys_unlink+0x195>
  ilock(dp);
80104bd6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bd9:	89 34 24             	mov    %esi,(%esp)
80104bdc:	e8 af ca ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104be1:	c7 44 24 04 3c 74 10 	movl   $0x8010743c,0x4(%esp)
80104be8:	80 
80104be9:	89 1c 24             	mov    %ebx,(%esp)
80104bec:	e8 7f cf ff ff       	call   80101b70 <namecmp>
80104bf1:	85 c0                	test   %eax,%eax
80104bf3:	0f 84 21 01 00 00    	je     80104d1a <sys_unlink+0x18a>
80104bf9:	c7 44 24 04 3b 74 10 	movl   $0x8010743b,0x4(%esp)
80104c00:	80 
80104c01:	89 1c 24             	mov    %ebx,(%esp)
80104c04:	e8 67 cf ff ff       	call   80101b70 <namecmp>
80104c09:	85 c0                	test   %eax,%eax
80104c0b:	0f 84 09 01 00 00    	je     80104d1a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c11:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c18:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c1c:	89 34 24             	mov    %esi,(%esp)
80104c1f:	e8 7c cf ff ff       	call   80101ba0 <dirlookup>
80104c24:	85 c0                	test   %eax,%eax
80104c26:	89 c3                	mov    %eax,%ebx
80104c28:	0f 84 ec 00 00 00    	je     80104d1a <sys_unlink+0x18a>
  ilock(ip);
80104c2e:	89 04 24             	mov    %eax,(%esp)
80104c31:	e8 5a ca ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
80104c36:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c3b:	0f 8e 24 01 00 00    	jle    80104d65 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c46:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c49:	74 7d                	je     80104cc8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c4b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c52:	00 
80104c53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c5a:	00 
80104c5b:	89 34 24             	mov    %esi,(%esp)
80104c5e:	e8 fd f5 ff ff       	call   80104260 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c66:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c6d:	00 
80104c6e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c72:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c79:	89 04 24             	mov    %eax,(%esp)
80104c7c:	e8 bf cd ff ff       	call   80101a40 <writei>
80104c81:	83 f8 10             	cmp    $0x10,%eax
80104c84:	0f 85 cf 00 00 00    	jne    80104d59 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104c8a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c8f:	0f 84 a3 00 00 00    	je     80104d38 <sys_unlink+0x1a8>
  iunlockput(dp);
80104c95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c98:	89 04 24             	mov    %eax,(%esp)
80104c9b:	e8 50 cc ff ff       	call   801018f0 <iunlockput>
  ip->nlink--;
80104ca0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ca5:	89 1c 24             	mov    %ebx,(%esp)
80104ca8:	e8 23 c9 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104cad:	89 1c 24             	mov    %ebx,(%esp)
80104cb0:	e8 3b cc ff ff       	call   801018f0 <iunlockput>
  end_op();
80104cb5:	e8 a6 de ff ff       	call   80102b60 <end_op>
}
80104cba:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104cbd:	31 c0                	xor    %eax,%eax
}
80104cbf:	5b                   	pop    %ebx
80104cc0:	5e                   	pop    %esi
80104cc1:	5f                   	pop    %edi
80104cc2:	5d                   	pop    %ebp
80104cc3:	c3                   	ret    
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104cc8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104ccc:	0f 86 79 ff ff ff    	jbe    80104c4b <sys_unlink+0xbb>
80104cd2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cd7:	eb 15                	jmp    80104cee <sys_unlink+0x15e>
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ce0:	8d 57 10             	lea    0x10(%edi),%edx
80104ce3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104ce6:	0f 83 5f ff ff ff    	jae    80104c4b <sys_unlink+0xbb>
80104cec:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cf5:	00 
80104cf6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cfa:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cfe:	89 1c 24             	mov    %ebx,(%esp)
80104d01:	e8 3a cc ff ff       	call   80101940 <readi>
80104d06:	83 f8 10             	cmp    $0x10,%eax
80104d09:	75 42                	jne    80104d4d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104d0b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d10:	74 ce                	je     80104ce0 <sys_unlink+0x150>
    iunlockput(ip);
80104d12:	89 1c 24             	mov    %ebx,(%esp)
80104d15:	e8 d6 cb ff ff       	call   801018f0 <iunlockput>
  iunlockput(dp);
80104d1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d1d:	89 04 24             	mov    %eax,(%esp)
80104d20:	e8 cb cb ff ff       	call   801018f0 <iunlockput>
  end_op();
80104d25:	e8 36 de ff ff       	call   80102b60 <end_op>
}
80104d2a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d32:	5b                   	pop    %ebx
80104d33:	5e                   	pop    %esi
80104d34:	5f                   	pop    %edi
80104d35:	5d                   	pop    %ebp
80104d36:	c3                   	ret    
80104d37:	90                   	nop
    dp->nlink--;
80104d38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d3b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d40:	89 04 24             	mov    %eax,(%esp)
80104d43:	e8 88 c8 ff ff       	call   801015d0 <iupdate>
80104d48:	e9 48 ff ff ff       	jmp    80104c95 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d4d:	c7 04 24 60 74 10 80 	movl   $0x80107460,(%esp)
80104d54:	e8 07 b6 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d59:	c7 04 24 72 74 10 80 	movl   $0x80107472,(%esp)
80104d60:	e8 fb b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104d65:	c7 04 24 4e 74 10 80 	movl   $0x8010744e,(%esp)
80104d6c:	e8 ef b5 ff ff       	call   80100360 <panic>
80104d71:	eb 0d                	jmp    80104d80 <sys_open>
80104d73:	90                   	nop
80104d74:	90                   	nop
80104d75:	90                   	nop
80104d76:	90                   	nop
80104d77:	90                   	nop
80104d78:	90                   	nop
80104d79:	90                   	nop
80104d7a:	90                   	nop
80104d7b:	90                   	nop
80104d7c:	90                   	nop
80104d7d:	90                   	nop
80104d7e:	90                   	nop
80104d7f:	90                   	nop

80104d80 <sys_open>:

int
sys_open(void)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	53                   	push   %ebx
80104d86:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d89:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d97:	e8 44 f8 ff ff       	call   801045e0 <argstr>
80104d9c:	85 c0                	test   %eax,%eax
80104d9e:	0f 88 d1 00 00 00    	js     80104e75 <sys_open+0xf5>
80104da4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104da7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104db2:	e8 99 f7 ff ff       	call   80104550 <argint>
80104db7:	85 c0                	test   %eax,%eax
80104db9:	0f 88 b6 00 00 00    	js     80104e75 <sys_open+0xf5>
    return -1;

  begin_op();
80104dbf:	e8 2c dd ff ff       	call   80102af0 <begin_op>

  if(omode & O_CREATE){
80104dc4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104dc8:	0f 85 82 00 00 00    	jne    80104e50 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104dce:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dd1:	89 04 24             	mov    %eax,(%esp)
80104dd4:	e8 07 d1 ff ff       	call   80101ee0 <namei>
80104dd9:	85 c0                	test   %eax,%eax
80104ddb:	89 c6                	mov    %eax,%esi
80104ddd:	0f 84 8d 00 00 00    	je     80104e70 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104de3:	89 04 24             	mov    %eax,(%esp)
80104de6:	e8 a5 c8 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104deb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104df0:	0f 84 92 00 00 00    	je     80104e88 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104df6:	e8 45 bf ff ff       	call   80100d40 <filealloc>
80104dfb:	85 c0                	test   %eax,%eax
80104dfd:	89 c3                	mov    %eax,%ebx
80104dff:	0f 84 93 00 00 00    	je     80104e98 <sys_open+0x118>
80104e05:	e8 86 f8 ff ff       	call   80104690 <fdalloc>
80104e0a:	85 c0                	test   %eax,%eax
80104e0c:	89 c7                	mov    %eax,%edi
80104e0e:	0f 88 94 00 00 00    	js     80104ea8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e14:	89 34 24             	mov    %esi,(%esp)
80104e17:	e8 54 c9 ff ff       	call   80101770 <iunlock>
  end_op();
80104e1c:	e8 3f dd ff ff       	call   80102b60 <end_op>

  f->type = FD_INODE;
80104e21:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e2a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e2d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e34:	89 c2                	mov    %eax,%edx
80104e36:	83 e2 01             	and    $0x1,%edx
80104e39:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e3c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e3e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e41:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e43:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e47:	83 c4 2c             	add    $0x2c,%esp
80104e4a:	5b                   	pop    %ebx
80104e4b:	5e                   	pop    %esi
80104e4c:	5f                   	pop    %edi
80104e4d:	5d                   	pop    %ebp
80104e4e:	c3                   	ret    
80104e4f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e53:	31 c9                	xor    %ecx,%ecx
80104e55:	ba 02 00 00 00       	mov    $0x2,%edx
80104e5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e61:	e8 6a f8 ff ff       	call   801046d0 <create>
    if(ip == 0){
80104e66:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104e68:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e6a:	75 8a                	jne    80104df6 <sys_open+0x76>
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104e70:	e8 eb dc ff ff       	call   80102b60 <end_op>
}
80104e75:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e7d:	5b                   	pop    %ebx
80104e7e:	5e                   	pop    %esi
80104e7f:	5f                   	pop    %edi
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	0f 84 63 ff ff ff    	je     80104df6 <sys_open+0x76>
80104e93:	90                   	nop
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104e98:	89 34 24             	mov    %esi,(%esp)
80104e9b:	e8 50 ca ff ff       	call   801018f0 <iunlockput>
80104ea0:	eb ce                	jmp    80104e70 <sys_open+0xf0>
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104ea8:	89 1c 24             	mov    %ebx,(%esp)
80104eab:	e8 50 bf ff ff       	call   80100e00 <fileclose>
80104eb0:	eb e6                	jmp    80104e98 <sys_open+0x118>
80104eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104ec6:	e8 25 dc ff ff       	call   80102af0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104ecb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ece:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ed2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ed9:	e8 02 f7 ff ff       	call   801045e0 <argstr>
80104ede:	85 c0                	test   %eax,%eax
80104ee0:	78 2e                	js     80104f10 <sys_mkdir+0x50>
80104ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee5:	31 c9                	xor    %ecx,%ecx
80104ee7:	ba 01 00 00 00       	mov    $0x1,%edx
80104eec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef3:	e8 d8 f7 ff ff       	call   801046d0 <create>
80104ef8:	85 c0                	test   %eax,%eax
80104efa:	74 14                	je     80104f10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104efc:	89 04 24             	mov    %eax,(%esp)
80104eff:	e8 ec c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104f04:	e8 57 dc ff ff       	call   80102b60 <end_op>
  return 0;
80104f09:	31 c0                	xor    %eax,%eax
}
80104f0b:	c9                   	leave  
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f10:	e8 4b dc ff ff       	call   80102b60 <end_op>
    return -1;
80104f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f20 <sys_mknod>:

int
sys_mknod(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f26:	e8 c5 db ff ff       	call   80102af0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f39:	e8 a2 f6 ff ff       	call   801045e0 <argstr>
80104f3e:	85 c0                	test   %eax,%eax
80104f40:	78 5e                	js     80104fa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f45:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f50:	e8 fb f5 ff ff       	call   80104550 <argint>
  if((argstr(0, &path)) < 0 ||
80104f55:	85 c0                	test   %eax,%eax
80104f57:	78 47                	js     80104fa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f60:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f67:	e8 e4 f5 ff ff       	call   80104550 <argint>
     argint(1, &major) < 0 ||
80104f6c:	85 c0                	test   %eax,%eax
80104f6e:	78 30                	js     80104fa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f70:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104f74:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f79:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f7d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f83:	e8 48 f7 ff ff       	call   801046d0 <create>
80104f88:	85 c0                	test   %eax,%eax
80104f8a:	74 14                	je     80104fa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f8c:	89 04 24             	mov    %eax,(%esp)
80104f8f:	e8 5c c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104f94:	e8 c7 db ff ff       	call   80102b60 <end_op>
  return 0;
80104f99:	31 c0                	xor    %eax,%eax
}
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104fa0:	e8 bb db ff ff       	call   80102b60 <end_op>
    return -1;
80104fa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104faa:	c9                   	leave  
80104fab:	c3                   	ret    
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <sys_chdir>:

int
sys_chdir(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104fb8:	e8 c3 e6 ff ff       	call   80103680 <myproc>
80104fbd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104fbf:	e8 2c db ff ff       	call   80102af0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fd2:	e8 09 f6 ff ff       	call   801045e0 <argstr>
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	78 4a                	js     80105025 <sys_chdir+0x75>
80104fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fde:	89 04 24             	mov    %eax,(%esp)
80104fe1:	e8 fa ce ff ff       	call   80101ee0 <namei>
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	89 c3                	mov    %eax,%ebx
80104fea:	74 39                	je     80105025 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fec:	89 04 24             	mov    %eax,(%esp)
80104fef:	e8 9c c6 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80104ff4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104ff9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104ffc:	75 22                	jne    80105020 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104ffe:	e8 6d c7 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105003:	8b 46 68             	mov    0x68(%esi),%eax
80105006:	89 04 24             	mov    %eax,(%esp)
80105009:	e8 a2 c7 ff ff       	call   801017b0 <iput>
  end_op();
8010500e:	e8 4d db ff ff       	call   80102b60 <end_op>
  curproc->cwd = ip;
  return 0;
80105013:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105015:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105018:	83 c4 20             	add    $0x20,%esp
8010501b:	5b                   	pop    %ebx
8010501c:	5e                   	pop    %esi
8010501d:	5d                   	pop    %ebp
8010501e:	c3                   	ret    
8010501f:	90                   	nop
    iunlockput(ip);
80105020:	e8 cb c8 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105025:	e8 36 db ff ff       	call   80102b60 <end_op>
}
8010502a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010502d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105032:	5b                   	pop    %ebx
80105033:	5e                   	pop    %esi
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    
80105036:	8d 76 00             	lea    0x0(%esi),%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <sys_exec>:

int
sys_exec(void)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010504c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105052:	89 44 24 04          	mov    %eax,0x4(%esp)
80105056:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010505d:	e8 7e f5 ff ff       	call   801045e0 <argstr>
80105062:	85 c0                	test   %eax,%eax
80105064:	0f 88 84 00 00 00    	js     801050ee <sys_exec+0xae>
8010506a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105070:	89 44 24 04          	mov    %eax,0x4(%esp)
80105074:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010507b:	e8 d0 f4 ff ff       	call   80104550 <argint>
80105080:	85 c0                	test   %eax,%eax
80105082:	78 6a                	js     801050ee <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105084:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010508a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010508c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105093:	00 
80105094:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010509a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050a1:	00 
801050a2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050a8:	89 04 24             	mov    %eax,(%esp)
801050ab:	e8 b0 f1 ff ff       	call   80104260 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801050b0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050ba:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050bd:	89 04 24             	mov    %eax,(%esp)
801050c0:	e8 eb f3 ff ff       	call   801044b0 <fetchint>
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 25                	js     801050ee <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801050c9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050cf:	85 c0                	test   %eax,%eax
801050d1:	74 2d                	je     80105100 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050d3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050d7:	89 04 24             	mov    %eax,(%esp)
801050da:	e8 11 f4 ff ff       	call   801044f0 <fetchstr>
801050df:	85 c0                	test   %eax,%eax
801050e1:	78 0b                	js     801050ee <sys_exec+0xae>
  for(i=0;; i++){
801050e3:	83 c3 01             	add    $0x1,%ebx
801050e6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050e9:	83 fb 20             	cmp    $0x20,%ebx
801050ec:	75 c2                	jne    801050b0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801050ee:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801050f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5f                   	pop    %edi
801050fc:	5d                   	pop    %ebp
801050fd:	c3                   	ret    
801050fe:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105100:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105106:	89 44 24 04          	mov    %eax,0x4(%esp)
8010510a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105110:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105117:	00 00 00 00 
  return exec(path, argv);
8010511b:	89 04 24             	mov    %eax,(%esp)
8010511e:	e8 7d b8 ff ff       	call   801009a0 <exec>
}
80105123:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5f                   	pop    %edi
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax

80105130 <sys_pipe>:

int
sys_pipe(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105137:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010513a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105141:	00 
80105142:	89 44 24 04          	mov    %eax,0x4(%esp)
80105146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010514d:	e8 2e f4 ff ff       	call   80104580 <argptr>
80105152:	85 c0                	test   %eax,%eax
80105154:	78 6d                	js     801051c3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105156:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105159:	89 44 24 04          	mov    %eax,0x4(%esp)
8010515d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105160:	89 04 24             	mov    %eax,(%esp)
80105163:	e8 e8 df ff ff       	call   80103150 <pipealloc>
80105168:	85 c0                	test   %eax,%eax
8010516a:	78 57                	js     801051c3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010516c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010516f:	e8 1c f5 ff ff       	call   80104690 <fdalloc>
80105174:	85 c0                	test   %eax,%eax
80105176:	89 c3                	mov    %eax,%ebx
80105178:	78 33                	js     801051ad <sys_pipe+0x7d>
8010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517d:	e8 0e f5 ff ff       	call   80104690 <fdalloc>
80105182:	85 c0                	test   %eax,%eax
80105184:	78 1a                	js     801051a0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105186:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105189:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010518b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010518e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105191:	83 c4 24             	add    $0x24,%esp
  return 0;
80105194:	31 c0                	xor    %eax,%eax
}
80105196:	5b                   	pop    %ebx
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801051a0:	e8 db e4 ff ff       	call   80103680 <myproc>
801051a5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801051ac:	00 
    fileclose(rf);
801051ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b0:	89 04 24             	mov    %eax,(%esp)
801051b3:	e8 48 bc ff ff       	call   80100e00 <fileclose>
    fileclose(wf);
801051b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bb:	89 04 24             	mov    %eax,(%esp)
801051be:	e8 3d bc ff ff       	call   80100e00 <fileclose>
}
801051c3:	83 c4 24             	add    $0x24,%esp
    return -1;
801051c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051cb:	5b                   	pop    %ebx
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret    
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051e4:	e8 67 f3 ff ff       	call   80104550 <argint>
801051e9:	85 c0                	test   %eax,%eax
801051eb:	78 33                	js     80105220 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801051ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801051f7:	00 
801051f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105203:	e8 78 f3 ff ff       	call   80104580 <argptr>
80105208:	85 c0                	test   %eax,%eax
8010520a:	78 14                	js     80105220 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010520c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105213:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105216:	89 04 24             	mov    %eax,(%esp)
80105219:	e8 a2 1a 00 00       	call   80106cc0 <shm_open>
}
8010521e:	c9                   	leave  
8010521f:	c3                   	ret    
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <sys_shm_close>:

int sys_shm_close(void) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105236:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105244:	e8 07 f3 ff ff       	call   80104550 <argint>
80105249:	85 c0                	test   %eax,%eax
8010524b:	78 13                	js     80105260 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010524d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105250:	89 04 24             	mov    %eax,(%esp)
80105253:	e8 78 1a 00 00       	call   80106cd0 <shm_close>
}
80105258:	c9                   	leave  
80105259:	c3                   	ret    
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_fork>:

int
sys_fork(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105273:	5d                   	pop    %ebp
  return fork();
80105274:	e9 b7 e5 ff ff       	jmp    80103830 <fork>
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_exit>:

int
sys_exit(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 08             	sub    $0x8,%esp
  exit();
80105286:	e8 f5 e7 ff ff       	call   80103a80 <exit>
  return 0;  // not reached
}
8010528b:	31 c0                	xor    %eax,%eax
8010528d:	c9                   	leave  
8010528e:	c3                   	ret    
8010528f:	90                   	nop

80105290 <sys_wait>:

int
sys_wait(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105293:	5d                   	pop    %ebp
  return wait();
80105294:	e9 f7 e9 ff ff       	jmp    80103c90 <wait>
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_kill>:

int
sys_kill(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b4:	e8 97 f2 ff ff       	call   80104550 <argint>
801052b9:	85 c0                	test   %eax,%eax
801052bb:	78 13                	js     801052d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c0:	89 04 24             	mov    %eax,(%esp)
801052c3:	e8 08 eb ff ff       	call   80103dd0 <kill>
}
801052c8:	c9                   	leave  
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_getpid>:

int
sys_getpid(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052e6:	e8 95 e3 ff ff       	call   80103680 <myproc>
801052eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    

801052f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105305:	e8 46 f2 ff ff       	call   80104550 <argint>
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 22                	js     80105330 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010530e:	e8 6d e3 ff ff       	call   80103680 <myproc>
  if(growproc(n) < 0)
80105313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105316:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105318:	89 14 24             	mov    %edx,(%esp)
8010531b:	e8 a0 e4 ff ff       	call   801037c0 <growproc>
80105320:	85 c0                	test   %eax,%eax
80105322:	78 0c                	js     80105330 <sys_sbrk+0x40>
    return -1;
  return addr;
80105324:	89 d8                	mov    %ebx,%eax
}
80105326:	83 c4 24             	add    $0x24,%esp
80105329:	5b                   	pop    %ebx
8010532a:	5d                   	pop    %ebp
8010532b:	c3                   	ret    
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105335:	eb ef                	jmp    80105326 <sys_sbrk+0x36>
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_sleep>:

int
sys_sleep(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010534a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105355:	e8 f6 f1 ff ff       	call   80104550 <argint>
8010535a:	85 c0                	test   %eax,%eax
8010535c:	78 7e                	js     801053dc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010535e:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105365:	e8 b6 ed ff ff       	call   80104120 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010536a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010536d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105373:	85 d2                	test   %edx,%edx
80105375:	75 29                	jne    801053a0 <sys_sleep+0x60>
80105377:	eb 4f                	jmp    801053c8 <sys_sleep+0x88>
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105380:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
80105387:	80 
80105388:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010538f:	e8 4c e8 ff ff       	call   80103be0 <sleep>
  while(ticks - ticks0 < n){
80105394:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105399:	29 d8                	sub    %ebx,%eax
8010539b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010539e:	73 28                	jae    801053c8 <sys_sleep+0x88>
    if(myproc()->killed){
801053a0:	e8 db e2 ff ff       	call   80103680 <myproc>
801053a5:	8b 40 24             	mov    0x24(%eax),%eax
801053a8:	85 c0                	test   %eax,%eax
801053aa:	74 d4                	je     80105380 <sys_sleep+0x40>
      release(&tickslock);
801053ac:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053b3:	e8 58 ee ff ff       	call   80104210 <release>
      return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801053bd:	83 c4 24             	add    $0x24,%esp
801053c0:	5b                   	pop    %ebx
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
801053c8:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053cf:	e8 3c ee ff ff       	call   80104210 <release>
}
801053d4:	83 c4 24             	add    $0x24,%esp
  return 0;
801053d7:	31 c0                	xor    %eax,%eax
}
801053d9:	5b                   	pop    %ebx
801053da:	5d                   	pop    %ebp
801053db:	c3                   	ret    
    return -1;
801053dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e1:	eb da                	jmp    801053bd <sys_sleep+0x7d>
801053e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053f7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053fe:	e8 1d ed ff ff       	call   80104120 <acquire>
  xticks = ticks;
80105403:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105409:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105410:	e8 fb ed ff ff       	call   80104210 <release>
  return xticks;
}
80105415:	83 c4 14             	add    $0x14,%esp
80105418:	89 d8                	mov    %ebx,%eax
8010541a:	5b                   	pop    %ebx
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    

8010541d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010541d:	1e                   	push   %ds
  pushl %es
8010541e:	06                   	push   %es
  pushl %fs
8010541f:	0f a0                	push   %fs
  pushl %gs
80105421:	0f a8                	push   %gs
  pushal
80105423:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105424:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105428:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010542a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010542c:	54                   	push   %esp
  call trap
8010542d:	e8 de 00 00 00       	call   80105510 <trap>
  addl $4, %esp
80105432:	83 c4 04             	add    $0x4,%esp

80105435 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105435:	61                   	popa   
  popl %gs
80105436:	0f a9                	pop    %gs
  popl %fs
80105438:	0f a1                	pop    %fs
  popl %es
8010543a:	07                   	pop    %es
  popl %ds
8010543b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010543c:	83 c4 08             	add    $0x8,%esp
  iret
8010543f:	cf                   	iret   

80105440 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105440:	31 c0                	xor    %eax,%eax
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105448:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010544f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105454:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
8010545b:	80 
8010545c:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80105463:	00 
80105464:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
8010546b:	8e 
8010546c:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105473:	80 
80105474:	c1 ea 10             	shr    $0x10,%edx
80105477:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
8010547e:	80 
  for(i = 0; i < 256; i++)
8010547f:	83 c0 01             	add    $0x1,%eax
80105482:	3d 00 01 00 00       	cmp    $0x100,%eax
80105487:	75 bf                	jne    80105448 <tvinit+0x8>
{
80105489:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010548a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010548f:	89 e5                	mov    %esp,%ebp
80105491:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105494:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105499:	c7 44 24 04 81 74 10 	movl   $0x80107481,0x4(%esp)
801054a0:	80 
801054a1:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054a8:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
801054af:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801054b5:	c1 e8 10             	shr    $0x10,%eax
801054b8:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
801054bf:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
801054c6:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801054cc:	e8 5f eb ff ff       	call   80104030 <initlock>
}
801054d1:	c9                   	leave  
801054d2:	c3                   	ret    
801054d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <idtinit>:

void
idtinit(void)
{
801054e0:	55                   	push   %ebp
  pd[0] = size-1;
801054e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054e6:	89 e5                	mov    %esp,%ebp
801054e8:	83 ec 10             	sub    $0x10,%esp
801054eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801054ef:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801054f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801054f8:	c1 e8 10             	shr    $0x10,%eax
801054fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801054ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105502:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	83 ec 3c             	sub    $0x3c,%esp
80105519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010551c:	8b 43 30             	mov    0x30(%ebx),%eax
8010551f:	83 f8 40             	cmp    $0x40,%eax
80105522:	0f 84 a0 01 00 00    	je     801056c8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105528:	83 e8 20             	sub    $0x20,%eax
8010552b:	83 f8 1f             	cmp    $0x1f,%eax
8010552e:	77 08                	ja     80105538 <trap+0x28>
80105530:	ff 24 85 28 75 10 80 	jmp    *-0x7fef8ad8(,%eax,4)
80105537:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105538:	e8 43 e1 ff ff       	call   80103680 <myproc>
8010553d:	85 c0                	test   %eax,%eax
8010553f:	90                   	nop
80105540:	0f 84 fa 01 00 00    	je     80105740 <trap+0x230>
80105546:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010554a:	0f 84 f0 01 00 00    	je     80105740 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105550:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105553:	8b 53 38             	mov    0x38(%ebx),%edx
80105556:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105559:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010555c:	e8 ff e0 ff ff       	call   80103660 <cpuid>
80105561:	8b 73 30             	mov    0x30(%ebx),%esi
80105564:	89 c7                	mov    %eax,%edi
80105566:	8b 43 34             	mov    0x34(%ebx),%eax
80105569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010556c:	e8 0f e1 ff ff       	call   80103680 <myproc>
80105571:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105574:	e8 07 e1 ff ff       	call   80103680 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105579:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010557c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105580:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105583:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105586:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010558a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010558e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105591:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105594:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105598:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010559c:	89 54 24 10          	mov    %edx,0x10(%esp)
801055a0:	8b 40 10             	mov    0x10(%eax),%eax
801055a3:	c7 04 24 e4 74 10 80 	movl   $0x801074e4,(%esp)
801055aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ae:	e8 9d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055b3:	e8 c8 e0 ff ff       	call   80103680 <myproc>
801055b8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055bf:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055c0:	e8 bb e0 ff ff       	call   80103680 <myproc>
801055c5:	85 c0                	test   %eax,%eax
801055c7:	74 0c                	je     801055d5 <trap+0xc5>
801055c9:	e8 b2 e0 ff ff       	call   80103680 <myproc>
801055ce:	8b 50 24             	mov    0x24(%eax),%edx
801055d1:	85 d2                	test   %edx,%edx
801055d3:	75 4b                	jne    80105620 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055d5:	e8 a6 e0 ff ff       	call   80103680 <myproc>
801055da:	85 c0                	test   %eax,%eax
801055dc:	74 0d                	je     801055eb <trap+0xdb>
801055de:	66 90                	xchg   %ax,%ax
801055e0:	e8 9b e0 ff ff       	call   80103680 <myproc>
801055e5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801055e9:	74 4d                	je     80105638 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055eb:	e8 90 e0 ff ff       	call   80103680 <myproc>
801055f0:	85 c0                	test   %eax,%eax
801055f2:	74 1d                	je     80105611 <trap+0x101>
801055f4:	e8 87 e0 ff ff       	call   80103680 <myproc>
801055f9:	8b 40 24             	mov    0x24(%eax),%eax
801055fc:	85 c0                	test   %eax,%eax
801055fe:	74 11                	je     80105611 <trap+0x101>
80105600:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105604:	83 e0 03             	and    $0x3,%eax
80105607:	66 83 f8 03          	cmp    $0x3,%ax
8010560b:	0f 84 e8 00 00 00    	je     801056f9 <trap+0x1e9>
    exit();
}
80105611:	83 c4 3c             	add    $0x3c,%esp
80105614:	5b                   	pop    %ebx
80105615:	5e                   	pop    %esi
80105616:	5f                   	pop    %edi
80105617:	5d                   	pop    %ebp
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105620:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105624:	83 e0 03             	and    $0x3,%eax
80105627:	66 83 f8 03          	cmp    $0x3,%ax
8010562b:	75 a8                	jne    801055d5 <trap+0xc5>
    exit();
8010562d:	e8 4e e4 ff ff       	call   80103a80 <exit>
80105632:	eb a1                	jmp    801055d5 <trap+0xc5>
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105638:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105640:	75 a9                	jne    801055eb <trap+0xdb>
    yield();
80105642:	e8 59 e5 ff ff       	call   80103ba0 <yield>
80105647:	eb a2                	jmp    801055eb <trap+0xdb>
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105650:	e8 0b e0 ff ff       	call   80103660 <cpuid>
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 84 b3 00 00 00    	je     80105710 <trap+0x200>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105660:	e8 fb d0 ff ff       	call   80102760 <lapiceoi>
    break;
80105665:	e9 56 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105670:	e8 3b cf ff ff       	call   801025b0 <kbdintr>
    lapiceoi();
80105675:	e8 e6 d0 ff ff       	call   80102760 <lapiceoi>
    break;
8010567a:	e9 41 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010567f:	90                   	nop
    uartintr();
80105680:	e8 1b 02 00 00       	call   801058a0 <uartintr>
    lapiceoi();
80105685:	e8 d6 d0 ff ff       	call   80102760 <lapiceoi>
    break;
8010568a:	e9 31 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010568f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105690:	8b 7b 38             	mov    0x38(%ebx),%edi
80105693:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105697:	e8 c4 df ff ff       	call   80103660 <cpuid>
8010569c:	c7 04 24 8c 74 10 80 	movl   $0x8010748c,(%esp)
801056a3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056a7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801056af:	e8 9c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
801056b4:	e8 a7 d0 ff ff       	call   80102760 <lapiceoi>
    break;
801056b9:	e9 02 ff ff ff       	jmp    801055c0 <trap+0xb0>
801056be:	66 90                	xchg   %ax,%ax
    ideintr();
801056c0:	e8 9b c9 ff ff       	call   80102060 <ideintr>
801056c5:	eb 96                	jmp    8010565d <trap+0x14d>
801056c7:	90                   	nop
801056c8:	90                   	nop
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801056d0:	e8 ab df ff ff       	call   80103680 <myproc>
801056d5:	8b 70 24             	mov    0x24(%eax),%esi
801056d8:	85 f6                	test   %esi,%esi
801056da:	75 2c                	jne    80105708 <trap+0x1f8>
    myproc()->tf = tf;
801056dc:	e8 9f df ff ff       	call   80103680 <myproc>
801056e1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801056e4:	e8 37 ef ff ff       	call   80104620 <syscall>
    if(myproc()->killed)
801056e9:	e8 92 df ff ff       	call   80103680 <myproc>
801056ee:	8b 48 24             	mov    0x24(%eax),%ecx
801056f1:	85 c9                	test   %ecx,%ecx
801056f3:	0f 84 18 ff ff ff    	je     80105611 <trap+0x101>
}
801056f9:	83 c4 3c             	add    $0x3c,%esp
801056fc:	5b                   	pop    %ebx
801056fd:	5e                   	pop    %esi
801056fe:	5f                   	pop    %edi
801056ff:	5d                   	pop    %ebp
      exit();
80105700:	e9 7b e3 ff ff       	jmp    80103a80 <exit>
80105705:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105708:	e8 73 e3 ff ff       	call   80103a80 <exit>
8010570d:	eb cd                	jmp    801056dc <trap+0x1cc>
8010570f:	90                   	nop
      acquire(&tickslock);
80105710:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105717:	e8 04 ea ff ff       	call   80104120 <acquire>
      wakeup(&ticks);
8010571c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105723:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010572a:	e8 41 e6 ff ff       	call   80103d70 <wakeup>
      release(&tickslock);
8010572f:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105736:	e8 d5 ea ff ff       	call   80104210 <release>
8010573b:	e9 1d ff ff ff       	jmp    8010565d <trap+0x14d>
80105740:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105743:	8b 73 38             	mov    0x38(%ebx),%esi
80105746:	e8 15 df ff ff       	call   80103660 <cpuid>
8010574b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010574f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105753:	89 44 24 08          	mov    %eax,0x8(%esp)
80105757:	8b 43 30             	mov    0x30(%ebx),%eax
8010575a:	c7 04 24 b0 74 10 80 	movl   $0x801074b0,(%esp)
80105761:	89 44 24 04          	mov    %eax,0x4(%esp)
80105765:	e8 e6 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
8010576a:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
80105771:	e8 ea ab ff ff       	call   80100360 <panic>
80105776:	66 90                	xchg   %ax,%ax
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105780:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105785:	55                   	push   %ebp
80105786:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105788:	85 c0                	test   %eax,%eax
8010578a:	74 14                	je     801057a0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010578c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105791:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105792:	a8 01                	test   $0x1,%al
80105794:	74 0a                	je     801057a0 <uartgetc+0x20>
80105796:	b2 f8                	mov    $0xf8,%dl
80105798:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105799:	0f b6 c0             	movzbl %al,%eax
}
8010579c:	5d                   	pop    %ebp
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <uartputc>:
  if(!uart)
801057b0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801057b5:	85 c0                	test   %eax,%eax
801057b7:	74 3f                	je     801057f8 <uartputc+0x48>
{
801057b9:	55                   	push   %ebp
801057ba:	89 e5                	mov    %esp,%ebp
801057bc:	56                   	push   %esi
801057bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801057c2:	53                   	push   %ebx
  if(!uart)
801057c3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801057c8:	83 ec 10             	sub    $0x10,%esp
801057cb:	eb 14                	jmp    801057e1 <uartputc+0x31>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801057d0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801057d7:	e8 a4 cf ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801057dc:	83 eb 01             	sub    $0x1,%ebx
801057df:	74 07                	je     801057e8 <uartputc+0x38>
801057e1:	89 f2                	mov    %esi,%edx
801057e3:	ec                   	in     (%dx),%al
801057e4:	a8 20                	test   $0x20,%al
801057e6:	74 e8                	je     801057d0 <uartputc+0x20>
  outb(COM1+0, c);
801057e8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801057ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057f1:	ee                   	out    %al,(%dx)
}
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	5b                   	pop    %ebx
801057f6:	5e                   	pop    %esi
801057f7:	5d                   	pop    %ebp
801057f8:	f3 c3                	repz ret 
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105800 <uartinit>:
{
80105800:	55                   	push   %ebp
80105801:	31 c9                	xor    %ecx,%ecx
80105803:	89 e5                	mov    %esp,%ebp
80105805:	89 c8                	mov    %ecx,%eax
80105807:	57                   	push   %edi
80105808:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010580d:	56                   	push   %esi
8010580e:	89 fa                	mov    %edi,%edx
80105810:	53                   	push   %ebx
80105811:	83 ec 1c             	sub    $0x1c,%esp
80105814:	ee                   	out    %al,(%dx)
80105815:	be fb 03 00 00       	mov    $0x3fb,%esi
8010581a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010581f:	89 f2                	mov    %esi,%edx
80105821:	ee                   	out    %al,(%dx)
80105822:	b8 0c 00 00 00       	mov    $0xc,%eax
80105827:	b2 f8                	mov    $0xf8,%dl
80105829:	ee                   	out    %al,(%dx)
8010582a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010582f:	89 c8                	mov    %ecx,%eax
80105831:	89 da                	mov    %ebx,%edx
80105833:	ee                   	out    %al,(%dx)
80105834:	b8 03 00 00 00       	mov    $0x3,%eax
80105839:	89 f2                	mov    %esi,%edx
8010583b:	ee                   	out    %al,(%dx)
8010583c:	b2 fc                	mov    $0xfc,%dl
8010583e:	89 c8                	mov    %ecx,%eax
80105840:	ee                   	out    %al,(%dx)
80105841:	b8 01 00 00 00       	mov    $0x1,%eax
80105846:	89 da                	mov    %ebx,%edx
80105848:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105849:	b2 fd                	mov    $0xfd,%dl
8010584b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010584c:	3c ff                	cmp    $0xff,%al
8010584e:	74 42                	je     80105892 <uartinit+0x92>
  uart = 1;
80105850:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105857:	00 00 00 
8010585a:	89 fa                	mov    %edi,%edx
8010585c:	ec                   	in     (%dx),%al
8010585d:	b2 f8                	mov    $0xf8,%dl
8010585f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105860:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105867:	00 
  for(p="xv6...\n"; *p; p++)
80105868:	bb a8 75 10 80       	mov    $0x801075a8,%ebx
  ioapicenable(IRQ_COM1, 0);
8010586d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105874:	e8 17 ca ff ff       	call   80102290 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105879:	b8 78 00 00 00       	mov    $0x78,%eax
8010587e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105880:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105883:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105886:	e8 25 ff ff ff       	call   801057b0 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010588b:	0f be 03             	movsbl (%ebx),%eax
8010588e:	84 c0                	test   %al,%al
80105890:	75 ee                	jne    80105880 <uartinit+0x80>
}
80105892:	83 c4 1c             	add    $0x1c,%esp
80105895:	5b                   	pop    %ebx
80105896:	5e                   	pop    %esi
80105897:	5f                   	pop    %edi
80105898:	5d                   	pop    %ebp
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <uartintr>:

void
uartintr(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058a6:	c7 04 24 80 57 10 80 	movl   $0x80105780,(%esp)
801058ad:	e8 fe ae ff ff       	call   801007b0 <consoleintr>
}
801058b2:	c9                   	leave  
801058b3:	c3                   	ret    

801058b4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $0
801058b6:	6a 00                	push   $0x0
  jmp alltraps
801058b8:	e9 60 fb ff ff       	jmp    8010541d <alltraps>

801058bd <vector1>:
.globl vector1
vector1:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $1
801058bf:	6a 01                	push   $0x1
  jmp alltraps
801058c1:	e9 57 fb ff ff       	jmp    8010541d <alltraps>

801058c6 <vector2>:
.globl vector2
vector2:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $2
801058c8:	6a 02                	push   $0x2
  jmp alltraps
801058ca:	e9 4e fb ff ff       	jmp    8010541d <alltraps>

801058cf <vector3>:
.globl vector3
vector3:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $3
801058d1:	6a 03                	push   $0x3
  jmp alltraps
801058d3:	e9 45 fb ff ff       	jmp    8010541d <alltraps>

801058d8 <vector4>:
.globl vector4
vector4:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $4
801058da:	6a 04                	push   $0x4
  jmp alltraps
801058dc:	e9 3c fb ff ff       	jmp    8010541d <alltraps>

801058e1 <vector5>:
.globl vector5
vector5:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $5
801058e3:	6a 05                	push   $0x5
  jmp alltraps
801058e5:	e9 33 fb ff ff       	jmp    8010541d <alltraps>

801058ea <vector6>:
.globl vector6
vector6:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $6
801058ec:	6a 06                	push   $0x6
  jmp alltraps
801058ee:	e9 2a fb ff ff       	jmp    8010541d <alltraps>

801058f3 <vector7>:
.globl vector7
vector7:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $7
801058f5:	6a 07                	push   $0x7
  jmp alltraps
801058f7:	e9 21 fb ff ff       	jmp    8010541d <alltraps>

801058fc <vector8>:
.globl vector8
vector8:
  pushl $8
801058fc:	6a 08                	push   $0x8
  jmp alltraps
801058fe:	e9 1a fb ff ff       	jmp    8010541d <alltraps>

80105903 <vector9>:
.globl vector9
vector9:
  pushl $0
80105903:	6a 00                	push   $0x0
  pushl $9
80105905:	6a 09                	push   $0x9
  jmp alltraps
80105907:	e9 11 fb ff ff       	jmp    8010541d <alltraps>

8010590c <vector10>:
.globl vector10
vector10:
  pushl $10
8010590c:	6a 0a                	push   $0xa
  jmp alltraps
8010590e:	e9 0a fb ff ff       	jmp    8010541d <alltraps>

80105913 <vector11>:
.globl vector11
vector11:
  pushl $11
80105913:	6a 0b                	push   $0xb
  jmp alltraps
80105915:	e9 03 fb ff ff       	jmp    8010541d <alltraps>

8010591a <vector12>:
.globl vector12
vector12:
  pushl $12
8010591a:	6a 0c                	push   $0xc
  jmp alltraps
8010591c:	e9 fc fa ff ff       	jmp    8010541d <alltraps>

80105921 <vector13>:
.globl vector13
vector13:
  pushl $13
80105921:	6a 0d                	push   $0xd
  jmp alltraps
80105923:	e9 f5 fa ff ff       	jmp    8010541d <alltraps>

80105928 <vector14>:
.globl vector14
vector14:
  pushl $14
80105928:	6a 0e                	push   $0xe
  jmp alltraps
8010592a:	e9 ee fa ff ff       	jmp    8010541d <alltraps>

8010592f <vector15>:
.globl vector15
vector15:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $15
80105931:	6a 0f                	push   $0xf
  jmp alltraps
80105933:	e9 e5 fa ff ff       	jmp    8010541d <alltraps>

80105938 <vector16>:
.globl vector16
vector16:
  pushl $0
80105938:	6a 00                	push   $0x0
  pushl $16
8010593a:	6a 10                	push   $0x10
  jmp alltraps
8010593c:	e9 dc fa ff ff       	jmp    8010541d <alltraps>

80105941 <vector17>:
.globl vector17
vector17:
  pushl $17
80105941:	6a 11                	push   $0x11
  jmp alltraps
80105943:	e9 d5 fa ff ff       	jmp    8010541d <alltraps>

80105948 <vector18>:
.globl vector18
vector18:
  pushl $0
80105948:	6a 00                	push   $0x0
  pushl $18
8010594a:	6a 12                	push   $0x12
  jmp alltraps
8010594c:	e9 cc fa ff ff       	jmp    8010541d <alltraps>

80105951 <vector19>:
.globl vector19
vector19:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $19
80105953:	6a 13                	push   $0x13
  jmp alltraps
80105955:	e9 c3 fa ff ff       	jmp    8010541d <alltraps>

8010595a <vector20>:
.globl vector20
vector20:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $20
8010595c:	6a 14                	push   $0x14
  jmp alltraps
8010595e:	e9 ba fa ff ff       	jmp    8010541d <alltraps>

80105963 <vector21>:
.globl vector21
vector21:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $21
80105965:	6a 15                	push   $0x15
  jmp alltraps
80105967:	e9 b1 fa ff ff       	jmp    8010541d <alltraps>

8010596c <vector22>:
.globl vector22
vector22:
  pushl $0
8010596c:	6a 00                	push   $0x0
  pushl $22
8010596e:	6a 16                	push   $0x16
  jmp alltraps
80105970:	e9 a8 fa ff ff       	jmp    8010541d <alltraps>

80105975 <vector23>:
.globl vector23
vector23:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $23
80105977:	6a 17                	push   $0x17
  jmp alltraps
80105979:	e9 9f fa ff ff       	jmp    8010541d <alltraps>

8010597e <vector24>:
.globl vector24
vector24:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $24
80105980:	6a 18                	push   $0x18
  jmp alltraps
80105982:	e9 96 fa ff ff       	jmp    8010541d <alltraps>

80105987 <vector25>:
.globl vector25
vector25:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $25
80105989:	6a 19                	push   $0x19
  jmp alltraps
8010598b:	e9 8d fa ff ff       	jmp    8010541d <alltraps>

80105990 <vector26>:
.globl vector26
vector26:
  pushl $0
80105990:	6a 00                	push   $0x0
  pushl $26
80105992:	6a 1a                	push   $0x1a
  jmp alltraps
80105994:	e9 84 fa ff ff       	jmp    8010541d <alltraps>

80105999 <vector27>:
.globl vector27
vector27:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $27
8010599b:	6a 1b                	push   $0x1b
  jmp alltraps
8010599d:	e9 7b fa ff ff       	jmp    8010541d <alltraps>

801059a2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $28
801059a4:	6a 1c                	push   $0x1c
  jmp alltraps
801059a6:	e9 72 fa ff ff       	jmp    8010541d <alltraps>

801059ab <vector29>:
.globl vector29
vector29:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $29
801059ad:	6a 1d                	push   $0x1d
  jmp alltraps
801059af:	e9 69 fa ff ff       	jmp    8010541d <alltraps>

801059b4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059b4:	6a 00                	push   $0x0
  pushl $30
801059b6:	6a 1e                	push   $0x1e
  jmp alltraps
801059b8:	e9 60 fa ff ff       	jmp    8010541d <alltraps>

801059bd <vector31>:
.globl vector31
vector31:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $31
801059bf:	6a 1f                	push   $0x1f
  jmp alltraps
801059c1:	e9 57 fa ff ff       	jmp    8010541d <alltraps>

801059c6 <vector32>:
.globl vector32
vector32:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $32
801059c8:	6a 20                	push   $0x20
  jmp alltraps
801059ca:	e9 4e fa ff ff       	jmp    8010541d <alltraps>

801059cf <vector33>:
.globl vector33
vector33:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $33
801059d1:	6a 21                	push   $0x21
  jmp alltraps
801059d3:	e9 45 fa ff ff       	jmp    8010541d <alltraps>

801059d8 <vector34>:
.globl vector34
vector34:
  pushl $0
801059d8:	6a 00                	push   $0x0
  pushl $34
801059da:	6a 22                	push   $0x22
  jmp alltraps
801059dc:	e9 3c fa ff ff       	jmp    8010541d <alltraps>

801059e1 <vector35>:
.globl vector35
vector35:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $35
801059e3:	6a 23                	push   $0x23
  jmp alltraps
801059e5:	e9 33 fa ff ff       	jmp    8010541d <alltraps>

801059ea <vector36>:
.globl vector36
vector36:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $36
801059ec:	6a 24                	push   $0x24
  jmp alltraps
801059ee:	e9 2a fa ff ff       	jmp    8010541d <alltraps>

801059f3 <vector37>:
.globl vector37
vector37:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $37
801059f5:	6a 25                	push   $0x25
  jmp alltraps
801059f7:	e9 21 fa ff ff       	jmp    8010541d <alltraps>

801059fc <vector38>:
.globl vector38
vector38:
  pushl $0
801059fc:	6a 00                	push   $0x0
  pushl $38
801059fe:	6a 26                	push   $0x26
  jmp alltraps
80105a00:	e9 18 fa ff ff       	jmp    8010541d <alltraps>

80105a05 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $39
80105a07:	6a 27                	push   $0x27
  jmp alltraps
80105a09:	e9 0f fa ff ff       	jmp    8010541d <alltraps>

80105a0e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $40
80105a10:	6a 28                	push   $0x28
  jmp alltraps
80105a12:	e9 06 fa ff ff       	jmp    8010541d <alltraps>

80105a17 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $41
80105a19:	6a 29                	push   $0x29
  jmp alltraps
80105a1b:	e9 fd f9 ff ff       	jmp    8010541d <alltraps>

80105a20 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a20:	6a 00                	push   $0x0
  pushl $42
80105a22:	6a 2a                	push   $0x2a
  jmp alltraps
80105a24:	e9 f4 f9 ff ff       	jmp    8010541d <alltraps>

80105a29 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $43
80105a2b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a2d:	e9 eb f9 ff ff       	jmp    8010541d <alltraps>

80105a32 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $44
80105a34:	6a 2c                	push   $0x2c
  jmp alltraps
80105a36:	e9 e2 f9 ff ff       	jmp    8010541d <alltraps>

80105a3b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $45
80105a3d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a3f:	e9 d9 f9 ff ff       	jmp    8010541d <alltraps>

80105a44 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a44:	6a 00                	push   $0x0
  pushl $46
80105a46:	6a 2e                	push   $0x2e
  jmp alltraps
80105a48:	e9 d0 f9 ff ff       	jmp    8010541d <alltraps>

80105a4d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $47
80105a4f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a51:	e9 c7 f9 ff ff       	jmp    8010541d <alltraps>

80105a56 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $48
80105a58:	6a 30                	push   $0x30
  jmp alltraps
80105a5a:	e9 be f9 ff ff       	jmp    8010541d <alltraps>

80105a5f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $49
80105a61:	6a 31                	push   $0x31
  jmp alltraps
80105a63:	e9 b5 f9 ff ff       	jmp    8010541d <alltraps>

80105a68 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $50
80105a6a:	6a 32                	push   $0x32
  jmp alltraps
80105a6c:	e9 ac f9 ff ff       	jmp    8010541d <alltraps>

80105a71 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $51
80105a73:	6a 33                	push   $0x33
  jmp alltraps
80105a75:	e9 a3 f9 ff ff       	jmp    8010541d <alltraps>

80105a7a <vector52>:
.globl vector52
vector52:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $52
80105a7c:	6a 34                	push   $0x34
  jmp alltraps
80105a7e:	e9 9a f9 ff ff       	jmp    8010541d <alltraps>

80105a83 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $53
80105a85:	6a 35                	push   $0x35
  jmp alltraps
80105a87:	e9 91 f9 ff ff       	jmp    8010541d <alltraps>

80105a8c <vector54>:
.globl vector54
vector54:
  pushl $0
80105a8c:	6a 00                	push   $0x0
  pushl $54
80105a8e:	6a 36                	push   $0x36
  jmp alltraps
80105a90:	e9 88 f9 ff ff       	jmp    8010541d <alltraps>

80105a95 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $55
80105a97:	6a 37                	push   $0x37
  jmp alltraps
80105a99:	e9 7f f9 ff ff       	jmp    8010541d <alltraps>

80105a9e <vector56>:
.globl vector56
vector56:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $56
80105aa0:	6a 38                	push   $0x38
  jmp alltraps
80105aa2:	e9 76 f9 ff ff       	jmp    8010541d <alltraps>

80105aa7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $57
80105aa9:	6a 39                	push   $0x39
  jmp alltraps
80105aab:	e9 6d f9 ff ff       	jmp    8010541d <alltraps>

80105ab0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $58
80105ab2:	6a 3a                	push   $0x3a
  jmp alltraps
80105ab4:	e9 64 f9 ff ff       	jmp    8010541d <alltraps>

80105ab9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $59
80105abb:	6a 3b                	push   $0x3b
  jmp alltraps
80105abd:	e9 5b f9 ff ff       	jmp    8010541d <alltraps>

80105ac2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $60
80105ac4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ac6:	e9 52 f9 ff ff       	jmp    8010541d <alltraps>

80105acb <vector61>:
.globl vector61
vector61:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $61
80105acd:	6a 3d                	push   $0x3d
  jmp alltraps
80105acf:	e9 49 f9 ff ff       	jmp    8010541d <alltraps>

80105ad4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $62
80105ad6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ad8:	e9 40 f9 ff ff       	jmp    8010541d <alltraps>

80105add <vector63>:
.globl vector63
vector63:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $63
80105adf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ae1:	e9 37 f9 ff ff       	jmp    8010541d <alltraps>

80105ae6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $64
80105ae8:	6a 40                	push   $0x40
  jmp alltraps
80105aea:	e9 2e f9 ff ff       	jmp    8010541d <alltraps>

80105aef <vector65>:
.globl vector65
vector65:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $65
80105af1:	6a 41                	push   $0x41
  jmp alltraps
80105af3:	e9 25 f9 ff ff       	jmp    8010541d <alltraps>

80105af8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $66
80105afa:	6a 42                	push   $0x42
  jmp alltraps
80105afc:	e9 1c f9 ff ff       	jmp    8010541d <alltraps>

80105b01 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $67
80105b03:	6a 43                	push   $0x43
  jmp alltraps
80105b05:	e9 13 f9 ff ff       	jmp    8010541d <alltraps>

80105b0a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $68
80105b0c:	6a 44                	push   $0x44
  jmp alltraps
80105b0e:	e9 0a f9 ff ff       	jmp    8010541d <alltraps>

80105b13 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $69
80105b15:	6a 45                	push   $0x45
  jmp alltraps
80105b17:	e9 01 f9 ff ff       	jmp    8010541d <alltraps>

80105b1c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $70
80105b1e:	6a 46                	push   $0x46
  jmp alltraps
80105b20:	e9 f8 f8 ff ff       	jmp    8010541d <alltraps>

80105b25 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $71
80105b27:	6a 47                	push   $0x47
  jmp alltraps
80105b29:	e9 ef f8 ff ff       	jmp    8010541d <alltraps>

80105b2e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $72
80105b30:	6a 48                	push   $0x48
  jmp alltraps
80105b32:	e9 e6 f8 ff ff       	jmp    8010541d <alltraps>

80105b37 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $73
80105b39:	6a 49                	push   $0x49
  jmp alltraps
80105b3b:	e9 dd f8 ff ff       	jmp    8010541d <alltraps>

80105b40 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $74
80105b42:	6a 4a                	push   $0x4a
  jmp alltraps
80105b44:	e9 d4 f8 ff ff       	jmp    8010541d <alltraps>

80105b49 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $75
80105b4b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b4d:	e9 cb f8 ff ff       	jmp    8010541d <alltraps>

80105b52 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $76
80105b54:	6a 4c                	push   $0x4c
  jmp alltraps
80105b56:	e9 c2 f8 ff ff       	jmp    8010541d <alltraps>

80105b5b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $77
80105b5d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b5f:	e9 b9 f8 ff ff       	jmp    8010541d <alltraps>

80105b64 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $78
80105b66:	6a 4e                	push   $0x4e
  jmp alltraps
80105b68:	e9 b0 f8 ff ff       	jmp    8010541d <alltraps>

80105b6d <vector79>:
.globl vector79
vector79:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $79
80105b6f:	6a 4f                	push   $0x4f
  jmp alltraps
80105b71:	e9 a7 f8 ff ff       	jmp    8010541d <alltraps>

80105b76 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $80
80105b78:	6a 50                	push   $0x50
  jmp alltraps
80105b7a:	e9 9e f8 ff ff       	jmp    8010541d <alltraps>

80105b7f <vector81>:
.globl vector81
vector81:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $81
80105b81:	6a 51                	push   $0x51
  jmp alltraps
80105b83:	e9 95 f8 ff ff       	jmp    8010541d <alltraps>

80105b88 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $82
80105b8a:	6a 52                	push   $0x52
  jmp alltraps
80105b8c:	e9 8c f8 ff ff       	jmp    8010541d <alltraps>

80105b91 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $83
80105b93:	6a 53                	push   $0x53
  jmp alltraps
80105b95:	e9 83 f8 ff ff       	jmp    8010541d <alltraps>

80105b9a <vector84>:
.globl vector84
vector84:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $84
80105b9c:	6a 54                	push   $0x54
  jmp alltraps
80105b9e:	e9 7a f8 ff ff       	jmp    8010541d <alltraps>

80105ba3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $85
80105ba5:	6a 55                	push   $0x55
  jmp alltraps
80105ba7:	e9 71 f8 ff ff       	jmp    8010541d <alltraps>

80105bac <vector86>:
.globl vector86
vector86:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $86
80105bae:	6a 56                	push   $0x56
  jmp alltraps
80105bb0:	e9 68 f8 ff ff       	jmp    8010541d <alltraps>

80105bb5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $87
80105bb7:	6a 57                	push   $0x57
  jmp alltraps
80105bb9:	e9 5f f8 ff ff       	jmp    8010541d <alltraps>

80105bbe <vector88>:
.globl vector88
vector88:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $88
80105bc0:	6a 58                	push   $0x58
  jmp alltraps
80105bc2:	e9 56 f8 ff ff       	jmp    8010541d <alltraps>

80105bc7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $89
80105bc9:	6a 59                	push   $0x59
  jmp alltraps
80105bcb:	e9 4d f8 ff ff       	jmp    8010541d <alltraps>

80105bd0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $90
80105bd2:	6a 5a                	push   $0x5a
  jmp alltraps
80105bd4:	e9 44 f8 ff ff       	jmp    8010541d <alltraps>

80105bd9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $91
80105bdb:	6a 5b                	push   $0x5b
  jmp alltraps
80105bdd:	e9 3b f8 ff ff       	jmp    8010541d <alltraps>

80105be2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $92
80105be4:	6a 5c                	push   $0x5c
  jmp alltraps
80105be6:	e9 32 f8 ff ff       	jmp    8010541d <alltraps>

80105beb <vector93>:
.globl vector93
vector93:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $93
80105bed:	6a 5d                	push   $0x5d
  jmp alltraps
80105bef:	e9 29 f8 ff ff       	jmp    8010541d <alltraps>

80105bf4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $94
80105bf6:	6a 5e                	push   $0x5e
  jmp alltraps
80105bf8:	e9 20 f8 ff ff       	jmp    8010541d <alltraps>

80105bfd <vector95>:
.globl vector95
vector95:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $95
80105bff:	6a 5f                	push   $0x5f
  jmp alltraps
80105c01:	e9 17 f8 ff ff       	jmp    8010541d <alltraps>

80105c06 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $96
80105c08:	6a 60                	push   $0x60
  jmp alltraps
80105c0a:	e9 0e f8 ff ff       	jmp    8010541d <alltraps>

80105c0f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $97
80105c11:	6a 61                	push   $0x61
  jmp alltraps
80105c13:	e9 05 f8 ff ff       	jmp    8010541d <alltraps>

80105c18 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $98
80105c1a:	6a 62                	push   $0x62
  jmp alltraps
80105c1c:	e9 fc f7 ff ff       	jmp    8010541d <alltraps>

80105c21 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $99
80105c23:	6a 63                	push   $0x63
  jmp alltraps
80105c25:	e9 f3 f7 ff ff       	jmp    8010541d <alltraps>

80105c2a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $100
80105c2c:	6a 64                	push   $0x64
  jmp alltraps
80105c2e:	e9 ea f7 ff ff       	jmp    8010541d <alltraps>

80105c33 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $101
80105c35:	6a 65                	push   $0x65
  jmp alltraps
80105c37:	e9 e1 f7 ff ff       	jmp    8010541d <alltraps>

80105c3c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $102
80105c3e:	6a 66                	push   $0x66
  jmp alltraps
80105c40:	e9 d8 f7 ff ff       	jmp    8010541d <alltraps>

80105c45 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $103
80105c47:	6a 67                	push   $0x67
  jmp alltraps
80105c49:	e9 cf f7 ff ff       	jmp    8010541d <alltraps>

80105c4e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $104
80105c50:	6a 68                	push   $0x68
  jmp alltraps
80105c52:	e9 c6 f7 ff ff       	jmp    8010541d <alltraps>

80105c57 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $105
80105c59:	6a 69                	push   $0x69
  jmp alltraps
80105c5b:	e9 bd f7 ff ff       	jmp    8010541d <alltraps>

80105c60 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $106
80105c62:	6a 6a                	push   $0x6a
  jmp alltraps
80105c64:	e9 b4 f7 ff ff       	jmp    8010541d <alltraps>

80105c69 <vector107>:
.globl vector107
vector107:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $107
80105c6b:	6a 6b                	push   $0x6b
  jmp alltraps
80105c6d:	e9 ab f7 ff ff       	jmp    8010541d <alltraps>

80105c72 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $108
80105c74:	6a 6c                	push   $0x6c
  jmp alltraps
80105c76:	e9 a2 f7 ff ff       	jmp    8010541d <alltraps>

80105c7b <vector109>:
.globl vector109
vector109:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $109
80105c7d:	6a 6d                	push   $0x6d
  jmp alltraps
80105c7f:	e9 99 f7 ff ff       	jmp    8010541d <alltraps>

80105c84 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $110
80105c86:	6a 6e                	push   $0x6e
  jmp alltraps
80105c88:	e9 90 f7 ff ff       	jmp    8010541d <alltraps>

80105c8d <vector111>:
.globl vector111
vector111:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $111
80105c8f:	6a 6f                	push   $0x6f
  jmp alltraps
80105c91:	e9 87 f7 ff ff       	jmp    8010541d <alltraps>

80105c96 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $112
80105c98:	6a 70                	push   $0x70
  jmp alltraps
80105c9a:	e9 7e f7 ff ff       	jmp    8010541d <alltraps>

80105c9f <vector113>:
.globl vector113
vector113:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $113
80105ca1:	6a 71                	push   $0x71
  jmp alltraps
80105ca3:	e9 75 f7 ff ff       	jmp    8010541d <alltraps>

80105ca8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $114
80105caa:	6a 72                	push   $0x72
  jmp alltraps
80105cac:	e9 6c f7 ff ff       	jmp    8010541d <alltraps>

80105cb1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $115
80105cb3:	6a 73                	push   $0x73
  jmp alltraps
80105cb5:	e9 63 f7 ff ff       	jmp    8010541d <alltraps>

80105cba <vector116>:
.globl vector116
vector116:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $116
80105cbc:	6a 74                	push   $0x74
  jmp alltraps
80105cbe:	e9 5a f7 ff ff       	jmp    8010541d <alltraps>

80105cc3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $117
80105cc5:	6a 75                	push   $0x75
  jmp alltraps
80105cc7:	e9 51 f7 ff ff       	jmp    8010541d <alltraps>

80105ccc <vector118>:
.globl vector118
vector118:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $118
80105cce:	6a 76                	push   $0x76
  jmp alltraps
80105cd0:	e9 48 f7 ff ff       	jmp    8010541d <alltraps>

80105cd5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $119
80105cd7:	6a 77                	push   $0x77
  jmp alltraps
80105cd9:	e9 3f f7 ff ff       	jmp    8010541d <alltraps>

80105cde <vector120>:
.globl vector120
vector120:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $120
80105ce0:	6a 78                	push   $0x78
  jmp alltraps
80105ce2:	e9 36 f7 ff ff       	jmp    8010541d <alltraps>

80105ce7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $121
80105ce9:	6a 79                	push   $0x79
  jmp alltraps
80105ceb:	e9 2d f7 ff ff       	jmp    8010541d <alltraps>

80105cf0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $122
80105cf2:	6a 7a                	push   $0x7a
  jmp alltraps
80105cf4:	e9 24 f7 ff ff       	jmp    8010541d <alltraps>

80105cf9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $123
80105cfb:	6a 7b                	push   $0x7b
  jmp alltraps
80105cfd:	e9 1b f7 ff ff       	jmp    8010541d <alltraps>

80105d02 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $124
80105d04:	6a 7c                	push   $0x7c
  jmp alltraps
80105d06:	e9 12 f7 ff ff       	jmp    8010541d <alltraps>

80105d0b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $125
80105d0d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d0f:	e9 09 f7 ff ff       	jmp    8010541d <alltraps>

80105d14 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $126
80105d16:	6a 7e                	push   $0x7e
  jmp alltraps
80105d18:	e9 00 f7 ff ff       	jmp    8010541d <alltraps>

80105d1d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $127
80105d1f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d21:	e9 f7 f6 ff ff       	jmp    8010541d <alltraps>

80105d26 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $128
80105d28:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d2d:	e9 eb f6 ff ff       	jmp    8010541d <alltraps>

80105d32 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $129
80105d34:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d39:	e9 df f6 ff ff       	jmp    8010541d <alltraps>

80105d3e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $130
80105d40:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d45:	e9 d3 f6 ff ff       	jmp    8010541d <alltraps>

80105d4a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $131
80105d4c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d51:	e9 c7 f6 ff ff       	jmp    8010541d <alltraps>

80105d56 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $132
80105d58:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d5d:	e9 bb f6 ff ff       	jmp    8010541d <alltraps>

80105d62 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $133
80105d64:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d69:	e9 af f6 ff ff       	jmp    8010541d <alltraps>

80105d6e <vector134>:
.globl vector134
vector134:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $134
80105d70:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d75:	e9 a3 f6 ff ff       	jmp    8010541d <alltraps>

80105d7a <vector135>:
.globl vector135
vector135:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $135
80105d7c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d81:	e9 97 f6 ff ff       	jmp    8010541d <alltraps>

80105d86 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $136
80105d88:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d8d:	e9 8b f6 ff ff       	jmp    8010541d <alltraps>

80105d92 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $137
80105d94:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d99:	e9 7f f6 ff ff       	jmp    8010541d <alltraps>

80105d9e <vector138>:
.globl vector138
vector138:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $138
80105da0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105da5:	e9 73 f6 ff ff       	jmp    8010541d <alltraps>

80105daa <vector139>:
.globl vector139
vector139:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $139
80105dac:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105db1:	e9 67 f6 ff ff       	jmp    8010541d <alltraps>

80105db6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $140
80105db8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dbd:	e9 5b f6 ff ff       	jmp    8010541d <alltraps>

80105dc2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $141
80105dc4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105dc9:	e9 4f f6 ff ff       	jmp    8010541d <alltraps>

80105dce <vector142>:
.globl vector142
vector142:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $142
80105dd0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105dd5:	e9 43 f6 ff ff       	jmp    8010541d <alltraps>

80105dda <vector143>:
.globl vector143
vector143:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $143
80105ddc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105de1:	e9 37 f6 ff ff       	jmp    8010541d <alltraps>

80105de6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $144
80105de8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ded:	e9 2b f6 ff ff       	jmp    8010541d <alltraps>

80105df2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $145
80105df4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105df9:	e9 1f f6 ff ff       	jmp    8010541d <alltraps>

80105dfe <vector146>:
.globl vector146
vector146:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $146
80105e00:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e05:	e9 13 f6 ff ff       	jmp    8010541d <alltraps>

80105e0a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $147
80105e0c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e11:	e9 07 f6 ff ff       	jmp    8010541d <alltraps>

80105e16 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $148
80105e18:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e1d:	e9 fb f5 ff ff       	jmp    8010541d <alltraps>

80105e22 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $149
80105e24:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e29:	e9 ef f5 ff ff       	jmp    8010541d <alltraps>

80105e2e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $150
80105e30:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e35:	e9 e3 f5 ff ff       	jmp    8010541d <alltraps>

80105e3a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $151
80105e3c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e41:	e9 d7 f5 ff ff       	jmp    8010541d <alltraps>

80105e46 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $152
80105e48:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e4d:	e9 cb f5 ff ff       	jmp    8010541d <alltraps>

80105e52 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $153
80105e54:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e59:	e9 bf f5 ff ff       	jmp    8010541d <alltraps>

80105e5e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $154
80105e60:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e65:	e9 b3 f5 ff ff       	jmp    8010541d <alltraps>

80105e6a <vector155>:
.globl vector155
vector155:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $155
80105e6c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e71:	e9 a7 f5 ff ff       	jmp    8010541d <alltraps>

80105e76 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $156
80105e78:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e7d:	e9 9b f5 ff ff       	jmp    8010541d <alltraps>

80105e82 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $157
80105e84:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e89:	e9 8f f5 ff ff       	jmp    8010541d <alltraps>

80105e8e <vector158>:
.globl vector158
vector158:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $158
80105e90:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e95:	e9 83 f5 ff ff       	jmp    8010541d <alltraps>

80105e9a <vector159>:
.globl vector159
vector159:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $159
80105e9c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ea1:	e9 77 f5 ff ff       	jmp    8010541d <alltraps>

80105ea6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $160
80105ea8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105ead:	e9 6b f5 ff ff       	jmp    8010541d <alltraps>

80105eb2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $161
80105eb4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105eb9:	e9 5f f5 ff ff       	jmp    8010541d <alltraps>

80105ebe <vector162>:
.globl vector162
vector162:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $162
80105ec0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105ec5:	e9 53 f5 ff ff       	jmp    8010541d <alltraps>

80105eca <vector163>:
.globl vector163
vector163:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $163
80105ecc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105ed1:	e9 47 f5 ff ff       	jmp    8010541d <alltraps>

80105ed6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $164
80105ed8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105edd:	e9 3b f5 ff ff       	jmp    8010541d <alltraps>

80105ee2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $165
80105ee4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ee9:	e9 2f f5 ff ff       	jmp    8010541d <alltraps>

80105eee <vector166>:
.globl vector166
vector166:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $166
80105ef0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ef5:	e9 23 f5 ff ff       	jmp    8010541d <alltraps>

80105efa <vector167>:
.globl vector167
vector167:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $167
80105efc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f01:	e9 17 f5 ff ff       	jmp    8010541d <alltraps>

80105f06 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $168
80105f08:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f0d:	e9 0b f5 ff ff       	jmp    8010541d <alltraps>

80105f12 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $169
80105f14:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f19:	e9 ff f4 ff ff       	jmp    8010541d <alltraps>

80105f1e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $170
80105f20:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f25:	e9 f3 f4 ff ff       	jmp    8010541d <alltraps>

80105f2a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $171
80105f2c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f31:	e9 e7 f4 ff ff       	jmp    8010541d <alltraps>

80105f36 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $172
80105f38:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f3d:	e9 db f4 ff ff       	jmp    8010541d <alltraps>

80105f42 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $173
80105f44:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f49:	e9 cf f4 ff ff       	jmp    8010541d <alltraps>

80105f4e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $174
80105f50:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f55:	e9 c3 f4 ff ff       	jmp    8010541d <alltraps>

80105f5a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $175
80105f5c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f61:	e9 b7 f4 ff ff       	jmp    8010541d <alltraps>

80105f66 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $176
80105f68:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f6d:	e9 ab f4 ff ff       	jmp    8010541d <alltraps>

80105f72 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $177
80105f74:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f79:	e9 9f f4 ff ff       	jmp    8010541d <alltraps>

80105f7e <vector178>:
.globl vector178
vector178:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $178
80105f80:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f85:	e9 93 f4 ff ff       	jmp    8010541d <alltraps>

80105f8a <vector179>:
.globl vector179
vector179:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $179
80105f8c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f91:	e9 87 f4 ff ff       	jmp    8010541d <alltraps>

80105f96 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $180
80105f98:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f9d:	e9 7b f4 ff ff       	jmp    8010541d <alltraps>

80105fa2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $181
80105fa4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105fa9:	e9 6f f4 ff ff       	jmp    8010541d <alltraps>

80105fae <vector182>:
.globl vector182
vector182:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $182
80105fb0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105fb5:	e9 63 f4 ff ff       	jmp    8010541d <alltraps>

80105fba <vector183>:
.globl vector183
vector183:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $183
80105fbc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105fc1:	e9 57 f4 ff ff       	jmp    8010541d <alltraps>

80105fc6 <vector184>:
.globl vector184
vector184:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $184
80105fc8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105fcd:	e9 4b f4 ff ff       	jmp    8010541d <alltraps>

80105fd2 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $185
80105fd4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105fd9:	e9 3f f4 ff ff       	jmp    8010541d <alltraps>

80105fde <vector186>:
.globl vector186
vector186:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $186
80105fe0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fe5:	e9 33 f4 ff ff       	jmp    8010541d <alltraps>

80105fea <vector187>:
.globl vector187
vector187:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $187
80105fec:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105ff1:	e9 27 f4 ff ff       	jmp    8010541d <alltraps>

80105ff6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $188
80105ff8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105ffd:	e9 1b f4 ff ff       	jmp    8010541d <alltraps>

80106002 <vector189>:
.globl vector189
vector189:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $189
80106004:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106009:	e9 0f f4 ff ff       	jmp    8010541d <alltraps>

8010600e <vector190>:
.globl vector190
vector190:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $190
80106010:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106015:	e9 03 f4 ff ff       	jmp    8010541d <alltraps>

8010601a <vector191>:
.globl vector191
vector191:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $191
8010601c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106021:	e9 f7 f3 ff ff       	jmp    8010541d <alltraps>

80106026 <vector192>:
.globl vector192
vector192:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $192
80106028:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010602d:	e9 eb f3 ff ff       	jmp    8010541d <alltraps>

80106032 <vector193>:
.globl vector193
vector193:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $193
80106034:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106039:	e9 df f3 ff ff       	jmp    8010541d <alltraps>

8010603e <vector194>:
.globl vector194
vector194:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $194
80106040:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106045:	e9 d3 f3 ff ff       	jmp    8010541d <alltraps>

8010604a <vector195>:
.globl vector195
vector195:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $195
8010604c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106051:	e9 c7 f3 ff ff       	jmp    8010541d <alltraps>

80106056 <vector196>:
.globl vector196
vector196:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $196
80106058:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010605d:	e9 bb f3 ff ff       	jmp    8010541d <alltraps>

80106062 <vector197>:
.globl vector197
vector197:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $197
80106064:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106069:	e9 af f3 ff ff       	jmp    8010541d <alltraps>

8010606e <vector198>:
.globl vector198
vector198:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $198
80106070:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106075:	e9 a3 f3 ff ff       	jmp    8010541d <alltraps>

8010607a <vector199>:
.globl vector199
vector199:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $199
8010607c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106081:	e9 97 f3 ff ff       	jmp    8010541d <alltraps>

80106086 <vector200>:
.globl vector200
vector200:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $200
80106088:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010608d:	e9 8b f3 ff ff       	jmp    8010541d <alltraps>

80106092 <vector201>:
.globl vector201
vector201:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $201
80106094:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106099:	e9 7f f3 ff ff       	jmp    8010541d <alltraps>

8010609e <vector202>:
.globl vector202
vector202:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $202
801060a0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060a5:	e9 73 f3 ff ff       	jmp    8010541d <alltraps>

801060aa <vector203>:
.globl vector203
vector203:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $203
801060ac:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060b1:	e9 67 f3 ff ff       	jmp    8010541d <alltraps>

801060b6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $204
801060b8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060bd:	e9 5b f3 ff ff       	jmp    8010541d <alltraps>

801060c2 <vector205>:
.globl vector205
vector205:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $205
801060c4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801060c9:	e9 4f f3 ff ff       	jmp    8010541d <alltraps>

801060ce <vector206>:
.globl vector206
vector206:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $206
801060d0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060d5:	e9 43 f3 ff ff       	jmp    8010541d <alltraps>

801060da <vector207>:
.globl vector207
vector207:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $207
801060dc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060e1:	e9 37 f3 ff ff       	jmp    8010541d <alltraps>

801060e6 <vector208>:
.globl vector208
vector208:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $208
801060e8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060ed:	e9 2b f3 ff ff       	jmp    8010541d <alltraps>

801060f2 <vector209>:
.globl vector209
vector209:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $209
801060f4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060f9:	e9 1f f3 ff ff       	jmp    8010541d <alltraps>

801060fe <vector210>:
.globl vector210
vector210:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $210
80106100:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106105:	e9 13 f3 ff ff       	jmp    8010541d <alltraps>

8010610a <vector211>:
.globl vector211
vector211:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $211
8010610c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106111:	e9 07 f3 ff ff       	jmp    8010541d <alltraps>

80106116 <vector212>:
.globl vector212
vector212:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $212
80106118:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010611d:	e9 fb f2 ff ff       	jmp    8010541d <alltraps>

80106122 <vector213>:
.globl vector213
vector213:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $213
80106124:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106129:	e9 ef f2 ff ff       	jmp    8010541d <alltraps>

8010612e <vector214>:
.globl vector214
vector214:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $214
80106130:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106135:	e9 e3 f2 ff ff       	jmp    8010541d <alltraps>

8010613a <vector215>:
.globl vector215
vector215:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $215
8010613c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106141:	e9 d7 f2 ff ff       	jmp    8010541d <alltraps>

80106146 <vector216>:
.globl vector216
vector216:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $216
80106148:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010614d:	e9 cb f2 ff ff       	jmp    8010541d <alltraps>

80106152 <vector217>:
.globl vector217
vector217:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $217
80106154:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106159:	e9 bf f2 ff ff       	jmp    8010541d <alltraps>

8010615e <vector218>:
.globl vector218
vector218:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $218
80106160:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106165:	e9 b3 f2 ff ff       	jmp    8010541d <alltraps>

8010616a <vector219>:
.globl vector219
vector219:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $219
8010616c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106171:	e9 a7 f2 ff ff       	jmp    8010541d <alltraps>

80106176 <vector220>:
.globl vector220
vector220:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $220
80106178:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010617d:	e9 9b f2 ff ff       	jmp    8010541d <alltraps>

80106182 <vector221>:
.globl vector221
vector221:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $221
80106184:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106189:	e9 8f f2 ff ff       	jmp    8010541d <alltraps>

8010618e <vector222>:
.globl vector222
vector222:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $222
80106190:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106195:	e9 83 f2 ff ff       	jmp    8010541d <alltraps>

8010619a <vector223>:
.globl vector223
vector223:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $223
8010619c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061a1:	e9 77 f2 ff ff       	jmp    8010541d <alltraps>

801061a6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $224
801061a8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061ad:	e9 6b f2 ff ff       	jmp    8010541d <alltraps>

801061b2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $225
801061b4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061b9:	e9 5f f2 ff ff       	jmp    8010541d <alltraps>

801061be <vector226>:
.globl vector226
vector226:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $226
801061c0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801061c5:	e9 53 f2 ff ff       	jmp    8010541d <alltraps>

801061ca <vector227>:
.globl vector227
vector227:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $227
801061cc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061d1:	e9 47 f2 ff ff       	jmp    8010541d <alltraps>

801061d6 <vector228>:
.globl vector228
vector228:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $228
801061d8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061dd:	e9 3b f2 ff ff       	jmp    8010541d <alltraps>

801061e2 <vector229>:
.globl vector229
vector229:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $229
801061e4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061e9:	e9 2f f2 ff ff       	jmp    8010541d <alltraps>

801061ee <vector230>:
.globl vector230
vector230:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $230
801061f0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061f5:	e9 23 f2 ff ff       	jmp    8010541d <alltraps>

801061fa <vector231>:
.globl vector231
vector231:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $231
801061fc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106201:	e9 17 f2 ff ff       	jmp    8010541d <alltraps>

80106206 <vector232>:
.globl vector232
vector232:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $232
80106208:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010620d:	e9 0b f2 ff ff       	jmp    8010541d <alltraps>

80106212 <vector233>:
.globl vector233
vector233:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $233
80106214:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106219:	e9 ff f1 ff ff       	jmp    8010541d <alltraps>

8010621e <vector234>:
.globl vector234
vector234:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $234
80106220:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106225:	e9 f3 f1 ff ff       	jmp    8010541d <alltraps>

8010622a <vector235>:
.globl vector235
vector235:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $235
8010622c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106231:	e9 e7 f1 ff ff       	jmp    8010541d <alltraps>

80106236 <vector236>:
.globl vector236
vector236:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $236
80106238:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010623d:	e9 db f1 ff ff       	jmp    8010541d <alltraps>

80106242 <vector237>:
.globl vector237
vector237:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $237
80106244:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106249:	e9 cf f1 ff ff       	jmp    8010541d <alltraps>

8010624e <vector238>:
.globl vector238
vector238:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $238
80106250:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106255:	e9 c3 f1 ff ff       	jmp    8010541d <alltraps>

8010625a <vector239>:
.globl vector239
vector239:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $239
8010625c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106261:	e9 b7 f1 ff ff       	jmp    8010541d <alltraps>

80106266 <vector240>:
.globl vector240
vector240:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $240
80106268:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010626d:	e9 ab f1 ff ff       	jmp    8010541d <alltraps>

80106272 <vector241>:
.globl vector241
vector241:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $241
80106274:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106279:	e9 9f f1 ff ff       	jmp    8010541d <alltraps>

8010627e <vector242>:
.globl vector242
vector242:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $242
80106280:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106285:	e9 93 f1 ff ff       	jmp    8010541d <alltraps>

8010628a <vector243>:
.globl vector243
vector243:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $243
8010628c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106291:	e9 87 f1 ff ff       	jmp    8010541d <alltraps>

80106296 <vector244>:
.globl vector244
vector244:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $244
80106298:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010629d:	e9 7b f1 ff ff       	jmp    8010541d <alltraps>

801062a2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $245
801062a4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062a9:	e9 6f f1 ff ff       	jmp    8010541d <alltraps>

801062ae <vector246>:
.globl vector246
vector246:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $246
801062b0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062b5:	e9 63 f1 ff ff       	jmp    8010541d <alltraps>

801062ba <vector247>:
.globl vector247
vector247:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $247
801062bc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801062c1:	e9 57 f1 ff ff       	jmp    8010541d <alltraps>

801062c6 <vector248>:
.globl vector248
vector248:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $248
801062c8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801062cd:	e9 4b f1 ff ff       	jmp    8010541d <alltraps>

801062d2 <vector249>:
.globl vector249
vector249:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $249
801062d4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062d9:	e9 3f f1 ff ff       	jmp    8010541d <alltraps>

801062de <vector250>:
.globl vector250
vector250:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $250
801062e0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062e5:	e9 33 f1 ff ff       	jmp    8010541d <alltraps>

801062ea <vector251>:
.globl vector251
vector251:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $251
801062ec:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062f1:	e9 27 f1 ff ff       	jmp    8010541d <alltraps>

801062f6 <vector252>:
.globl vector252
vector252:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $252
801062f8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062fd:	e9 1b f1 ff ff       	jmp    8010541d <alltraps>

80106302 <vector253>:
.globl vector253
vector253:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $253
80106304:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106309:	e9 0f f1 ff ff       	jmp    8010541d <alltraps>

8010630e <vector254>:
.globl vector254
vector254:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $254
80106310:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106315:	e9 03 f1 ff ff       	jmp    8010541d <alltraps>

8010631a <vector255>:
.globl vector255
vector255:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $255
8010631c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106321:	e9 f7 f0 ff ff       	jmp    8010541d <alltraps>
80106326:	66 90                	xchg   %ax,%ax
80106328:	66 90                	xchg   %ax,%ax
8010632a:	66 90                	xchg   %ax,%ax
8010632c:	66 90                	xchg   %ax,%ax
8010632e:	66 90                	xchg   %ax,%ax

80106330 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	56                   	push   %esi
80106335:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106337:	c1 ea 16             	shr    $0x16,%edx
{
8010633a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010633b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010633e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106341:	8b 1f                	mov    (%edi),%ebx
80106343:	f6 c3 01             	test   $0x1,%bl
80106346:	74 28                	je     80106370 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106348:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010634e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106354:	c1 ee 0a             	shr    $0xa,%esi
}
80106357:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010635a:	89 f2                	mov    %esi,%edx
8010635c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106362:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106365:	5b                   	pop    %ebx
80106366:	5e                   	pop    %esi
80106367:	5f                   	pop    %edi
80106368:	5d                   	pop    %ebp
80106369:	c3                   	ret    
8010636a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106370:	85 c9                	test   %ecx,%ecx
80106372:	74 34                	je     801063a8 <walkpgdir+0x78>
80106374:	e8 07 c1 ff ff       	call   80102480 <kalloc>
80106379:	85 c0                	test   %eax,%eax
8010637b:	89 c3                	mov    %eax,%ebx
8010637d:	74 29                	je     801063a8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010637f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106386:	00 
80106387:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010638e:	00 
8010638f:	89 04 24             	mov    %eax,(%esp)
80106392:	e8 c9 de ff ff       	call   80104260 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106397:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010639d:	83 c8 07             	or     $0x7,%eax
801063a0:	89 07                	mov    %eax,(%edi)
801063a2:	eb b0                	jmp    80106354 <walkpgdir+0x24>
801063a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801063a8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801063ab:	31 c0                	xor    %eax,%eax
}
801063ad:	5b                   	pop    %ebx
801063ae:	5e                   	pop    %esi
801063af:	5f                   	pop    %edi
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    
801063b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	89 c7                	mov    %eax,%edi
801063c6:	56                   	push   %esi
801063c7:	89 d6                	mov    %edx,%esi
801063c9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801063ca:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063d0:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
801063d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801063d9:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801063de:	72 3b                	jb     8010641b <deallocuvm.part.0+0x5b>
801063e0:	eb 5e                	jmp    80106440 <deallocuvm.part.0+0x80>
801063e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801063e8:	8b 10                	mov    (%eax),%edx
801063ea:	f6 c2 01             	test   $0x1,%dl
801063ed:	74 22                	je     80106411 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801063ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801063f5:	74 54                	je     8010644b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801063f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801063fd:	89 14 24             	mov    %edx,(%esp)
80106400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106403:	e8 c8 be ff ff       	call   801022d0 <kfree>
      *pte = 0;
80106408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010640b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106417:	39 f3                	cmp    %esi,%ebx
80106419:	73 25                	jae    80106440 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010641b:	31 c9                	xor    %ecx,%ecx
8010641d:	89 da                	mov    %ebx,%edx
8010641f:	89 f8                	mov    %edi,%eax
80106421:	e8 0a ff ff ff       	call   80106330 <walkpgdir>
    if(!pte)
80106426:	85 c0                	test   %eax,%eax
80106428:	75 be                	jne    801063e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010642a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106430:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010643c:	39 f3                	cmp    %esi,%ebx
8010643e:	72 db                	jb     8010641b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106440:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106443:	83 c4 1c             	add    $0x1c,%esp
80106446:	5b                   	pop    %ebx
80106447:	5e                   	pop    %esi
80106448:	5f                   	pop    %edi
80106449:	5d                   	pop    %ebp
8010644a:	c3                   	ret    
        panic("kfree");
8010644b:	c7 04 24 46 6f 10 80 	movl   $0x80106f46,(%esp)
80106452:	e8 09 9f ff ff       	call   80100360 <panic>
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106460 <seginit>:
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106466:	e8 f5 d1 ff ff       	call   80103660 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010646b:	31 c9                	xor    %ecx,%ecx
8010646d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106472:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106478:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010647d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106481:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106486:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106489:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010648d:	31 c9                	xor    %ecx,%ecx
8010648f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106493:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106498:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010649c:	31 c9                	xor    %ecx,%ecx
8010649e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064a2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064a7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064ab:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064ad:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801064b1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064b5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801064b9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064bd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801064c1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064c5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801064c9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801064cd:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
801064d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064d6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801064da:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064de:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801064e2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064e6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801064ea:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064ee:	66 89 48 22          	mov    %cx,0x22(%eax)
801064f2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801064f6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801064fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801064fe:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106502:	c1 e8 10             	shr    $0x10,%eax
80106505:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106509:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010650c:	0f 01 10             	lgdtl  (%eax)
}
8010650f:	c9                   	leave  
80106510:	c3                   	ret    
80106511:	eb 0d                	jmp    80106520 <mappages>
80106513:	90                   	nop
80106514:	90                   	nop
80106515:	90                   	nop
80106516:	90                   	nop
80106517:	90                   	nop
80106518:	90                   	nop
80106519:	90                   	nop
8010651a:	90                   	nop
8010651b:	90                   	nop
8010651c:	90                   	nop
8010651d:	90                   	nop
8010651e:	90                   	nop
8010651f:	90                   	nop

80106520 <mappages>:
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	56                   	push   %esi
80106525:	53                   	push   %ebx
80106526:	83 ec 1c             	sub    $0x1c,%esp
80106529:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010652c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010652f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106532:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106536:	89 c3                	mov    %eax,%ebx
80106538:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010653e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106542:	29 df                	sub    %ebx,%edi
80106544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106547:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010654e:	eb 15                	jmp    80106565 <mappages+0x45>
    if(*pte & PTE_P)
80106550:	f6 00 01             	testb  $0x1,(%eax)
80106553:	75 3d                	jne    80106592 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106555:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106558:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010655b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010655d:	74 29                	je     80106588 <mappages+0x68>
    a += PGSIZE;
8010655f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106565:	8b 45 08             	mov    0x8(%ebp),%eax
80106568:	b9 01 00 00 00       	mov    $0x1,%ecx
8010656d:	89 da                	mov    %ebx,%edx
8010656f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106572:	e8 b9 fd ff ff       	call   80106330 <walkpgdir>
80106577:	85 c0                	test   %eax,%eax
80106579:	75 d5                	jne    80106550 <mappages+0x30>
}
8010657b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010657e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106583:	5b                   	pop    %ebx
80106584:	5e                   	pop    %esi
80106585:	5f                   	pop    %edi
80106586:	5d                   	pop    %ebp
80106587:	c3                   	ret    
80106588:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010658b:	31 c0                	xor    %eax,%eax
}
8010658d:	5b                   	pop    %ebx
8010658e:	5e                   	pop    %esi
8010658f:	5f                   	pop    %edi
80106590:	5d                   	pop    %ebp
80106591:	c3                   	ret    
      panic("remap");
80106592:	c7 04 24 b0 75 10 80 	movl   $0x801075b0,(%esp)
80106599:	e8 c2 9d ff ff       	call   80100360 <panic>
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065a0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
801065a5:	55                   	push   %ebp
801065a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065ad:	0f 22 d8             	mov    %eax,%cr3
}
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
801065b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <switchuvm>:
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	56                   	push   %esi
801065c5:	53                   	push   %ebx
801065c6:	83 ec 1c             	sub    $0x1c,%esp
801065c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801065cc:	85 f6                	test   %esi,%esi
801065ce:	0f 84 cd 00 00 00    	je     801066a1 <switchuvm+0xe1>
  if(p->kstack == 0)
801065d4:	8b 46 08             	mov    0x8(%esi),%eax
801065d7:	85 c0                	test   %eax,%eax
801065d9:	0f 84 da 00 00 00    	je     801066b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801065df:	8b 7e 04             	mov    0x4(%esi),%edi
801065e2:	85 ff                	test   %edi,%edi
801065e4:	0f 84 c3 00 00 00    	je     801066ad <switchuvm+0xed>
  pushcli();
801065ea:	e8 f1 da ff ff       	call   801040e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801065ef:	e8 ec cf ff ff       	call   801035e0 <mycpu>
801065f4:	89 c3                	mov    %eax,%ebx
801065f6:	e8 e5 cf ff ff       	call   801035e0 <mycpu>
801065fb:	89 c7                	mov    %eax,%edi
801065fd:	e8 de cf ff ff       	call   801035e0 <mycpu>
80106602:	83 c7 08             	add    $0x8,%edi
80106605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106608:	e8 d3 cf ff ff       	call   801035e0 <mycpu>
8010660d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106610:	ba 67 00 00 00       	mov    $0x67,%edx
80106615:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010661c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106623:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010662a:	83 c1 08             	add    $0x8,%ecx
8010662d:	c1 e9 10             	shr    $0x10,%ecx
80106630:	83 c0 08             	add    $0x8,%eax
80106633:	c1 e8 18             	shr    $0x18,%eax
80106636:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010663c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106643:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106649:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010664e:	e8 8d cf ff ff       	call   801035e0 <mycpu>
80106653:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010665a:	e8 81 cf ff ff       	call   801035e0 <mycpu>
8010665f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106664:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106668:	e8 73 cf ff ff       	call   801035e0 <mycpu>
8010666d:	8b 56 08             	mov    0x8(%esi),%edx
80106670:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106676:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106679:	e8 62 cf ff ff       	call   801035e0 <mycpu>
8010667e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106682:	b8 28 00 00 00       	mov    $0x28,%eax
80106687:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010668a:	8b 46 04             	mov    0x4(%esi),%eax
8010668d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106692:	0f 22 d8             	mov    %eax,%cr3
}
80106695:	83 c4 1c             	add    $0x1c,%esp
80106698:	5b                   	pop    %ebx
80106699:	5e                   	pop    %esi
8010669a:	5f                   	pop    %edi
8010669b:	5d                   	pop    %ebp
  popcli();
8010669c:	e9 ff da ff ff       	jmp    801041a0 <popcli>
    panic("switchuvm: no process");
801066a1:	c7 04 24 b6 75 10 80 	movl   $0x801075b6,(%esp)
801066a8:	e8 b3 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801066ad:	c7 04 24 e1 75 10 80 	movl   $0x801075e1,(%esp)
801066b4:	e8 a7 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
801066b9:	c7 04 24 cc 75 10 80 	movl   $0x801075cc,(%esp)
801066c0:	e8 9b 9c ff ff       	call   80100360 <panic>
801066c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066d0 <inituvm>:
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 2c             	sub    $0x2c,%esp
801066d9:	8b 75 10             	mov    0x10(%ebp),%esi
801066dc:	8b 55 08             	mov    0x8(%ebp),%edx
801066df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801066e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066e8:	77 64                	ja     8010674e <inituvm+0x7e>
801066ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
801066ed:	e8 8e bd ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
801066f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066f9:	00 
801066fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106701:	00 
80106702:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106705:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106707:	e8 54 db ff ff       	call   80104260 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010670c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010670f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106715:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010671c:	00 
8010671d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106721:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106728:	00 
80106729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106730:	00 
80106731:	89 14 24             	mov    %edx,(%esp)
80106734:	e8 e7 fd ff ff       	call   80106520 <mappages>
  memmove(mem, init, sz);
80106739:	89 75 10             	mov    %esi,0x10(%ebp)
8010673c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010673f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106742:	83 c4 2c             	add    $0x2c,%esp
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106749:	e9 b2 db ff ff       	jmp    80104300 <memmove>
    panic("inituvm: more than a page");
8010674e:	c7 04 24 f5 75 10 80 	movl   $0x801075f5,(%esp)
80106755:	e8 06 9c ff ff       	call   80100360 <panic>
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <loaduvm>:
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	53                   	push   %ebx
80106766:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106769:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106770:	0f 85 98 00 00 00    	jne    8010680e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106776:	8b 75 18             	mov    0x18(%ebp),%esi
80106779:	31 db                	xor    %ebx,%ebx
8010677b:	85 f6                	test   %esi,%esi
8010677d:	75 1a                	jne    80106799 <loaduvm+0x39>
8010677f:	eb 77                	jmp    801067f8 <loaduvm+0x98>
80106781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106788:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010678e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106794:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106797:	76 5f                	jbe    801067f8 <loaduvm+0x98>
80106799:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010679c:	31 c9                	xor    %ecx,%ecx
8010679e:	8b 45 08             	mov    0x8(%ebp),%eax
801067a1:	01 da                	add    %ebx,%edx
801067a3:	e8 88 fb ff ff       	call   80106330 <walkpgdir>
801067a8:	85 c0                	test   %eax,%eax
801067aa:	74 56                	je     80106802 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801067ac:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801067ae:	bf 00 10 00 00       	mov    $0x1000,%edi
801067b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
801067b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
801067bb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801067c1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801067c4:	05 00 00 00 80       	add    $0x80000000,%eax
801067c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067cd:	8b 45 10             	mov    0x10(%ebp),%eax
801067d0:	01 d9                	add    %ebx,%ecx
801067d2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801067d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067da:	89 04 24             	mov    %eax,(%esp)
801067dd:	e8 5e b1 ff ff       	call   80101940 <readi>
801067e2:	39 f8                	cmp    %edi,%eax
801067e4:	74 a2                	je     80106788 <loaduvm+0x28>
}
801067e6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801067e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067ee:	5b                   	pop    %ebx
801067ef:	5e                   	pop    %esi
801067f0:	5f                   	pop    %edi
801067f1:	5d                   	pop    %ebp
801067f2:	c3                   	ret    
801067f3:	90                   	nop
801067f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067f8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801067fb:	31 c0                	xor    %eax,%eax
}
801067fd:	5b                   	pop    %ebx
801067fe:	5e                   	pop    %esi
801067ff:	5f                   	pop    %edi
80106800:	5d                   	pop    %ebp
80106801:	c3                   	ret    
      panic("loaduvm: address should exist");
80106802:	c7 04 24 0f 76 10 80 	movl   $0x8010760f,(%esp)
80106809:	e8 52 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010680e:	c7 04 24 b0 76 10 80 	movl   $0x801076b0,(%esp)
80106815:	e8 46 9b ff ff       	call   80100360 <panic>
8010681a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106820 <allocuvm>:
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	53                   	push   %ebx
80106826:	83 ec 2c             	sub    $0x2c,%esp
80106829:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010682c:	85 ff                	test   %edi,%edi
8010682e:	0f 88 8f 00 00 00    	js     801068c3 <allocuvm+0xa3>
  if(newsz < oldsz)
80106834:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106837:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010683a:	0f 82 85 00 00 00    	jb     801068c5 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106840:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106846:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010684c:	39 df                	cmp    %ebx,%edi
8010684e:	77 57                	ja     801068a7 <allocuvm+0x87>
80106850:	eb 7e                	jmp    801068d0 <allocuvm+0xb0>
80106852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106858:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010685f:	00 
80106860:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106867:	00 
80106868:	89 04 24             	mov    %eax,(%esp)
8010686b:	e8 f0 d9 ff ff       	call   80104260 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106870:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106876:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010687a:	8b 45 08             	mov    0x8(%ebp),%eax
8010687d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106884:	00 
80106885:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010688c:	00 
8010688d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106891:	89 04 24             	mov    %eax,(%esp)
80106894:	e8 87 fc ff ff       	call   80106520 <mappages>
80106899:	85 c0                	test   %eax,%eax
8010689b:	78 43                	js     801068e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
8010689d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068a3:	39 df                	cmp    %ebx,%edi
801068a5:	76 29                	jbe    801068d0 <allocuvm+0xb0>
    mem = kalloc();
801068a7:	e8 d4 bb ff ff       	call   80102480 <kalloc>
    if(mem == 0){
801068ac:	85 c0                	test   %eax,%eax
    mem = kalloc();
801068ae:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801068b0:	75 a6                	jne    80106858 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801068b2:	c7 04 24 2d 76 10 80 	movl   $0x8010762d,(%esp)
801068b9:	e8 92 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068be:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068c1:	77 47                	ja     8010690a <allocuvm+0xea>
      return 0;
801068c3:	31 c0                	xor    %eax,%eax
}
801068c5:	83 c4 2c             	add    $0x2c,%esp
801068c8:	5b                   	pop    %ebx
801068c9:	5e                   	pop    %esi
801068ca:	5f                   	pop    %edi
801068cb:	5d                   	pop    %ebp
801068cc:	c3                   	ret    
801068cd:	8d 76 00             	lea    0x0(%esi),%esi
801068d0:	83 c4 2c             	add    $0x2c,%esp
801068d3:	89 f8                	mov    %edi,%eax
801068d5:	5b                   	pop    %ebx
801068d6:	5e                   	pop    %esi
801068d7:	5f                   	pop    %edi
801068d8:	5d                   	pop    %ebp
801068d9:	c3                   	ret    
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801068e0:	c7 04 24 45 76 10 80 	movl   $0x80107645,(%esp)
801068e7:	e8 64 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068ec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068ef:	76 0d                	jbe    801068fe <allocuvm+0xde>
801068f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068f4:	89 fa                	mov    %edi,%edx
801068f6:	8b 45 08             	mov    0x8(%ebp),%eax
801068f9:	e8 c2 fa ff ff       	call   801063c0 <deallocuvm.part.0>
      kfree(mem);
801068fe:	89 34 24             	mov    %esi,(%esp)
80106901:	e8 ca b9 ff ff       	call   801022d0 <kfree>
      return 0;
80106906:	31 c0                	xor    %eax,%eax
80106908:	eb bb                	jmp    801068c5 <allocuvm+0xa5>
8010690a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010690d:	89 fa                	mov    %edi,%edx
8010690f:	8b 45 08             	mov    0x8(%ebp),%eax
80106912:	e8 a9 fa ff ff       	call   801063c0 <deallocuvm.part.0>
      return 0;
80106917:	31 c0                	xor    %eax,%eax
80106919:	eb aa                	jmp    801068c5 <allocuvm+0xa5>
8010691b:	90                   	nop
8010691c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106920 <deallocuvm>:
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	8b 55 0c             	mov    0xc(%ebp),%edx
80106926:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106929:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010692c:	39 d1                	cmp    %edx,%ecx
8010692e:	73 08                	jae    80106938 <deallocuvm+0x18>
}
80106930:	5d                   	pop    %ebp
80106931:	e9 8a fa ff ff       	jmp    801063c0 <deallocuvm.part.0>
80106936:	66 90                	xchg   %ax,%ax
80106938:	89 d0                	mov    %edx,%eax
8010693a:	5d                   	pop    %ebp
8010693b:	c3                   	ret    
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	56                   	push   %esi
80106944:	53                   	push   %ebx
80106945:	83 ec 10             	sub    $0x10,%esp
80106948:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010694b:	85 f6                	test   %esi,%esi
8010694d:	74 59                	je     801069a8 <freevm+0x68>
8010694f:	31 c9                	xor    %ecx,%ecx
80106951:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106956:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106958:	31 db                	xor    %ebx,%ebx
8010695a:	e8 61 fa ff ff       	call   801063c0 <deallocuvm.part.0>
8010695f:	eb 12                	jmp    80106973 <freevm+0x33>
80106961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106968:	83 c3 01             	add    $0x1,%ebx
8010696b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106971:	74 27                	je     8010699a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106973:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106976:	f6 c2 01             	test   $0x1,%dl
80106979:	74 ed                	je     80106968 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010697b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106981:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106984:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010698a:	89 14 24             	mov    %edx,(%esp)
8010698d:	e8 3e b9 ff ff       	call   801022d0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106992:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106998:	75 d9                	jne    80106973 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
8010699a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010699d:	83 c4 10             	add    $0x10,%esp
801069a0:	5b                   	pop    %ebx
801069a1:	5e                   	pop    %esi
801069a2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801069a3:	e9 28 b9 ff ff       	jmp    801022d0 <kfree>
    panic("freevm: no pgdir");
801069a8:	c7 04 24 61 76 10 80 	movl   $0x80107661,(%esp)
801069af:	e8 ac 99 ff ff       	call   80100360 <panic>
801069b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801069c0 <setupkvm>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	56                   	push   %esi
801069c4:	53                   	push   %ebx
801069c5:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
801069c8:	e8 b3 ba ff ff       	call   80102480 <kalloc>
801069cd:	85 c0                	test   %eax,%eax
801069cf:	89 c6                	mov    %eax,%esi
801069d1:	74 75                	je     80106a48 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
801069d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069da:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069db:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801069e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069e7:	00 
801069e8:	89 04 24             	mov    %eax,(%esp)
801069eb:	e8 70 d8 ff ff       	call   80104260 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069f0:	8b 53 0c             	mov    0xc(%ebx),%edx
801069f3:	8b 43 04             	mov    0x4(%ebx),%eax
801069f6:	89 34 24             	mov    %esi,(%esp)
801069f9:	89 54 24 10          	mov    %edx,0x10(%esp)
801069fd:	8b 53 08             	mov    0x8(%ebx),%edx
80106a00:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a04:	29 c2                	sub    %eax,%edx
80106a06:	8b 03                	mov    (%ebx),%eax
80106a08:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a10:	e8 0b fb ff ff       	call   80106520 <mappages>
80106a15:	85 c0                	test   %eax,%eax
80106a17:	78 17                	js     80106a30 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a19:	83 c3 10             	add    $0x10,%ebx
80106a1c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a22:	72 cc                	jb     801069f0 <setupkvm+0x30>
80106a24:	89 f0                	mov    %esi,%eax
}
80106a26:	83 c4 20             	add    $0x20,%esp
80106a29:	5b                   	pop    %ebx
80106a2a:	5e                   	pop    %esi
80106a2b:	5d                   	pop    %ebp
80106a2c:	c3                   	ret    
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106a30:	89 34 24             	mov    %esi,(%esp)
80106a33:	e8 08 ff ff ff       	call   80106940 <freevm>
}
80106a38:	83 c4 20             	add    $0x20,%esp
      return 0;
80106a3b:	31 c0                	xor    %eax,%eax
}
80106a3d:	5b                   	pop    %ebx
80106a3e:	5e                   	pop    %esi
80106a3f:	5d                   	pop    %ebp
80106a40:	c3                   	ret    
80106a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a48:	31 c0                	xor    %eax,%eax
80106a4a:	eb da                	jmp    80106a26 <setupkvm+0x66>
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <kvmalloc>:
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a56:	e8 65 ff ff ff       	call   801069c0 <setupkvm>
80106a5b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a60:	05 00 00 00 80       	add    $0x80000000,%eax
80106a65:	0f 22 d8             	mov    %eax,%cr3
}
80106a68:	c9                   	leave  
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a71:	31 c9                	xor    %ecx,%ecx
{
80106a73:	89 e5                	mov    %esp,%ebp
80106a75:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106a78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7e:	e8 ad f8 ff ff       	call   80106330 <walkpgdir>
  if(pte == 0)
80106a83:	85 c0                	test   %eax,%eax
80106a85:	74 05                	je     80106a8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106a87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106a8a:	c9                   	leave  
80106a8b:	c3                   	ret    
    panic("clearpteu");
80106a8c:	c7 04 24 72 76 10 80 	movl   $0x80107672,(%esp)
80106a93:	e8 c8 98 ff ff       	call   80100360 <panic>
80106a98:	90                   	nop
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106aa9:	e8 12 ff ff ff       	call   801069c0 <setupkvm>
80106aae:	85 c0                	test   %eax,%eax
80106ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ab3:	0f 84 ba 00 00 00    	je     80106b73 <copyuvm+0xd3>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106abc:	85 c0                	test   %eax,%eax
80106abe:	0f 84 a4 00 00 00    	je     80106b68 <copyuvm+0xc8>
80106ac4:	31 db                	xor    %ebx,%ebx
80106ac6:	eb 51                	jmp    80106b19 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ac8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ace:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ad5:	00 
80106ad6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106ada:	89 04 24             	mov    %eax,(%esp)
80106add:	e8 1e d8 ff ff       	call   80104300 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106aeb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106aef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106af6:	00 
80106af7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106afb:	89 44 24 10          	mov    %eax,0x10(%esp)
80106aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b02:	89 04 24             	mov    %eax,(%esp)
80106b05:	e8 16 fa ff ff       	call   80106520 <mappages>
80106b0a:	85 c0                	test   %eax,%eax
80106b0c:	78 45                	js     80106b53 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
80106b0e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b14:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b17:	76 4f                	jbe    80106b68 <copyuvm+0xc8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b19:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1c:	31 c9                	xor    %ecx,%ecx
80106b1e:	89 da                	mov    %ebx,%edx
80106b20:	e8 0b f8 ff ff       	call   80106330 <walkpgdir>
80106b25:	85 c0                	test   %eax,%eax
80106b27:	74 5a                	je     80106b83 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106b29:	8b 30                	mov    (%eax),%esi
80106b2b:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b31:	74 44                	je     80106b77 <copyuvm+0xd7>
    pa = PTE_ADDR(*pte);
80106b33:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b35:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b3b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b3e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106b44:	e8 37 b9 ff ff       	call   80102480 <kalloc>
80106b49:	85 c0                	test   %eax,%eax
80106b4b:	89 c6                	mov    %eax,%esi
80106b4d:	0f 85 75 ff ff ff    	jne    80106ac8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b56:	89 04 24             	mov    %eax,(%esp)
80106b59:	e8 e2 fd ff ff       	call   80106940 <freevm>
  return 0;
80106b5e:	31 c0                	xor    %eax,%eax
}
80106b60:	83 c4 2c             	add    $0x2c,%esp
80106b63:	5b                   	pop    %ebx
80106b64:	5e                   	pop    %esi
80106b65:	5f                   	pop    %edi
80106b66:	5d                   	pop    %ebp
80106b67:	c3                   	ret    
80106b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b6b:	83 c4 2c             	add    $0x2c,%esp
80106b6e:	5b                   	pop    %ebx
80106b6f:	5e                   	pop    %esi
80106b70:	5f                   	pop    %edi
80106b71:	5d                   	pop    %ebp
80106b72:	c3                   	ret    
    return 0;
80106b73:	31 c0                	xor    %eax,%eax
80106b75:	eb e9                	jmp    80106b60 <copyuvm+0xc0>
      panic("copyuvm: page not present");
80106b77:	c7 04 24 96 76 10 80 	movl   $0x80107696,(%esp)
80106b7e:	e8 dd 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106b83:	c7 04 24 7c 76 10 80 	movl   $0x8010767c,(%esp)
80106b8a:	e8 d1 97 ff ff       	call   80100360 <panic>
80106b8f:	90                   	nop

80106b90 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106b90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b91:	31 c9                	xor    %ecx,%ecx
{
80106b93:	89 e5                	mov    %esp,%ebp
80106b95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106b98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9e:	e8 8d f7 ff ff       	call   80106330 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ba3:	8b 00                	mov    (%eax),%eax
80106ba5:	89 c2                	mov    %eax,%edx
80106ba7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106baa:	83 fa 05             	cmp    $0x5,%edx
80106bad:	75 11                	jne    80106bc0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106baf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bb4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106bb9:	c9                   	leave  
80106bba:	c3                   	ret    
80106bbb:	90                   	nop
80106bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106bc0:	31 c0                	xor    %eax,%eax
}
80106bc2:	c9                   	leave  
80106bc3:	c3                   	ret    
80106bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	83 ec 1c             	sub    $0x1c,%esp
80106bd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bdf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106be2:	85 db                	test   %ebx,%ebx
80106be4:	75 3a                	jne    80106c20 <copyout+0x50>
80106be6:	eb 68                	jmp    80106c50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106be8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106beb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106bed:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106bf1:	29 ca                	sub    %ecx,%edx
80106bf3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106bf9:	39 da                	cmp    %ebx,%edx
80106bfb:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106bfe:	29 f1                	sub    %esi,%ecx
80106c00:	01 c8                	add    %ecx,%eax
80106c02:	89 54 24 08          	mov    %edx,0x8(%esp)
80106c06:	89 04 24             	mov    %eax,(%esp)
80106c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106c0c:	e8 ef d6 ff ff       	call   80104300 <memmove>
    len -= n;
    buf += n;
80106c11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106c14:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106c1a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106c1c:	29 d3                	sub    %edx,%ebx
80106c1e:	74 30                	je     80106c50 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106c23:	89 ce                	mov    %ecx,%esi
80106c25:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106c2b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106c2f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106c32:	89 04 24             	mov    %eax,(%esp)
80106c35:	e8 56 ff ff ff       	call   80106b90 <uva2ka>
    if(pa0 == 0)
80106c3a:	85 c0                	test   %eax,%eax
80106c3c:	75 aa                	jne    80106be8 <copyout+0x18>
  }
  return 0;
}
80106c3e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
80106c4a:	c3                   	ret    
80106c4b:	90                   	nop
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c50:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106c53:	31 c0                	xor    %eax,%eax
}
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
80106c5a:	66 90                	xchg   %ax,%ax
80106c5c:	66 90                	xchg   %ax,%ax
80106c5e:	66 90                	xchg   %ax,%ax

80106c60 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106c66:	c7 44 24 04 d4 76 10 	movl   $0x801076d4,0x4(%esp)
80106c6d:	80 
80106c6e:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
80106c75:	e8 b6 d3 ff ff       	call   80104030 <initlock>
  acquire(&(shm_table.lock));
80106c7a:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
80106c81:	e8 9a d4 ff ff       	call   80104120 <acquire>
80106c86:	b8 f4 54 11 80       	mov    $0x801154f4,%eax
80106c8b:	90                   	nop
80106c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106c96:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106c99:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106ca0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106ca7:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80106cac:	75 e2                	jne    80106c90 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106cae:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
80106cb5:	e8 56 d5 ff ff       	call   80104210 <release>
}
80106cba:	c9                   	leave  
80106cbb:	c3                   	ret    
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <shm_open>:

int shm_open(int id, char **pointer) {
80106cc0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106cc1:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106cc3:	89 e5                	mov    %esp,%ebp
}
80106cc5:	5d                   	pop    %ebp
80106cc6:	c3                   	ret    
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <shm_close>:


int shm_close(int id) {
80106cd0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106cd1:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106cd3:	89 e5                	mov    %esp,%ebp
}
80106cd5:	5d                   	pop    %ebp
80106cd6:	c3                   	ret    
