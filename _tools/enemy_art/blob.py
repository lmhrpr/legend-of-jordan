"""Gelatinous blobs: see-through jelly with a darker core, a bright rim where the light catches it,
a glossy highlight and a few bubbles; the outline is a deep shade of the jelly's own colour."""
from PIL import Image
import math
def lerp(a,b,t): return tuple(int(a[i]+(b[i]-a[i])*t) for i in range(3))
def blob(phase, base, W=20, Hh=17):
    w,h,lift={0:(16,9,0),1:(11,13,0),2:(13,10,5),3:(18,7,0)}[phase]
    cx=W/2-0.5; cy=Hh-1.5-lift-h/2
    deep=lerp(base,(0,0,0),0.55); dark=lerp(base,(0,0,0),0.3); light=lerp(base,(255,255,255),0.35); rim=lerp(base,(255,255,255),0.6)
    im=Image.new('RGBA',(W,Hh),(0,0,0,0)); px=im.load()
    inside=set()
    for y in range(Hh):
        for x in range(W):
            dx=(x-cx)/(w/2); dy=(y-cy)/(h/2)
            d=dx*dx+(dy*dy*(0.75 if dy>0 else 1.0))
            if d<=1: inside.add((x,y))
    for _ in range(2):   # no lone pixels sticking out of the outline
        inside={p for p in inside if sum(((p[0]+a,p[1]+b) in inside) for a,b in ((1,0),(-1,0),(0,1),(0,-1)))>=2}
    if phase==2:   # a soft shadow on the ground
        for x in range(W):
            for y in range(Hh-3,Hh):
                if ((x-cx)/5.5)**2+((y-(Hh-1.5))/0.9)**2<=1: px[x,y]=(0,0,0,70)
    for (x,y) in inside:
        dx=(x-cx)/(w/2); dy=(y-cy)/(h/2); r=math.hypot(dx,dy)
        c=base; a=205
        if dy>0.25: c=dark                       # heavier jelly at the bottom
        if r<0.45 and dy>-0.2: c=lerp(dark,deep,0.5); a=230   # the core
        if r>0.78 and (dx+dy)<-0.2: c=light; a=225            # the rim catching the light
        if r>0.8 and (dx+dy)>0.6: c=deep; a=235
        px[x,y]=c+(a,)
    # glossy highlight and bubbles
    hx,hy=int(cx-w*0.22),int(cy-h*0.22)
    for p in [(hx,hy),(hx+1,hy),(hx,hy+1),(hx+1,hy-1) if phase!=1 else (hx,hy-1)]:
        if p in inside: px[p]=(255,255,255,250)
    for (bx,by) in [(int(cx+w*0.2),int(cy+h*0.05)),(int(cx-w*0.05),int(cy+h*0.25)),(int(cx+w*0.28),int(cy-h*0.2))]:
        if (bx,by) in inside: px[bx,by]=rim+(240,)
    # eyes
    ey=int(cy-h*0.08)
    for ex in (int(cx-2),int(cx+2)):
        if (ex,ey) in inside: px[ex,ey]=(10,10,10,255); 
        if (ex,ey+1) in inside: px[ex,ey+1]=(10,10,10,255)
        if (ex-1,ey) in inside and ex<cx: pass
    # outline: a deep shade of its own colour
    for (x,y) in inside:
        for ddx,ddy in ((1,0),(-1,0),(0,1),(0,-1)):
            n=(x+ddx,y+ddy)
            if n not in inside and 0<=n[0]<W and 0<=n[1]<Hh: px[n]=lerp(base,(0,0,0),0.75)+(255,)
    return im
BLOBS={'green (slow)':(70,170,70),'blue (fast)':(60,120,220),'purple (splits once)':(150,80,200),'red (splits twice)':(210,60,70)}
frames={k:[blob(p,c) for p in (0,1,2,3)] for k,c in BLOBS.items()}
if __name__=='__main__':
    S=7; fs=[f for k in frames for f in frames[k]]
    per=4; rows=len(frames)
    im=Image.new('RGBA',(per*(20*S+10),rows*(17*S+10)),(74,150,70,255))
    for i,f in enumerate(fs): im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),((i%per)*(20*S+10),(i//per)*(17*S+10)))
    im.save('/tmp/claude-0/blobs.png')
