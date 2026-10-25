from PIL import Image
import math, random
R=[(120,88,58),(150,114,76),(182,146,100),(212,180,132),(236,212,170),(250,238,210)]
def dust(ph,W=22,H=28):
    rnd=random.Random(ph*7)
    im=Image.new('RGBA',(W,H),(0,0,0,0)); px=im.load()
    inside={}
    for y in range(H):
        if y<2: continue
        t=(y-2)/(H-3)
        half=max(0.9,9.0*(1-t)**1.25)+0.8*math.sin(y*0.6+ph*1.6)
        if y<5: half-= (5-y)*1.6                     # a rounded, billowing top
        cx=W/2-0.5+2.4*math.sin(y*0.28+ph*1.2)*t
        for x in range(W):
            if abs(x-cx)<=half:
                s=math.sin((x-cx)*0.8+y*0.75-ph*1.7)
                v=4 if s>0.5 else 3 if s>0 else 2 if s>-0.5 else 1
                if x-cx<-half+1.5: v+=1               # lit side
                if x-cx>half-1.2: v-=1                # shade side
                if y<5: v+=1
                inside[(x,y)]=max(0,min(5,v))
    for (x,y),v in inside.items():
        a=255 if y<H*0.7 else int(255*(1-(y-H*0.7)/(H*0.3))*0.8+60)   # thins out to dust at its foot
        px[x,y]=R[v]+(a,)
    for (x,y) in inside:
        for dx,dy in ((1,0),(-1,0),(0,1),(0,-1)):
            n=(x+dx,y+dy)
            if n not in inside and 0<=n[0]<W and 0<=n[1]<H and y<H*0.8: px[n]=(40,28,20,255)
    for _ in range(7):    # grit flying round it
        a=rnd.uniform(0,6.28); rr=rnd.uniform(6,10); y=rnd.randint(4,H-3)
        x=int(W/2+math.cos(a+ph)*rr); 
        if 0<=x<W and (x,y) not in inside: px[x,y]=R[rnd.choice((0,1,4))]+(255,)
    return im
frames={'dust devil':[dust(p) for p in range(4)]}
if __name__=='__main__':
    S=6; fs=frames['dust devil']
    im=Image.new('RGBA',(sum(f.width*S+10 for f in fs),26*S),(74,150,70,255)); x=0
    for f in fs: im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),(x,0)); x+=f.width*S+10
    im.save('/tmp/claude-0/dust.png')
