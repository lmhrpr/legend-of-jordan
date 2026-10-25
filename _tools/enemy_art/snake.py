from px import shade, flip
from PIL import Image
import math
GR=[(30,64,40),(48,100,52),(76,144,64),(122,186,84),(178,222,122)]
BELLY=[(150,130,60),(206,182,84),(238,220,130)]
mats={'B':GR,'H':GR,'Y':BELLY,'k':[(14,14,14)],'w':[(250,250,236)],'r':[(214,52,62)],'d':[(28,52,32)]}
def tex(m,x,y,i,h):
    if m=='B' and (x//2+y)%4==0 and h>=2: i-=2      # dark blotches down its back
    return i
def slither(ph, W=28, Hh=11):
    """Seen from above, moving right: an S-curve travelling along the body."""
    g=[['.']*W for _ in range(Hh)]
    hx=W-4
    for x in range(W):
        t=x/(hx)
        if x<=hx-2:
            cy=Hh/2-0.5+2.0*math.sin(x*0.45-ph*math.pi/2)*(0.35+0.65*(1-t))
            r=0.7+1.5*min(1,t)
            for y in range(Hh):
                if abs(y-cy)<=r: g[y][x]='B'
    # the head: a rounded wedge where the curve ends
    cyh=Hh/2-0.5+2.0*math.sin((hx-2)*0.45-ph*math.pi/2)*0.35
    for x in range(hx-3,W):
        for y in range(Hh):
            dx=(x-(hx-0.5))/3.4; dy=(y-cyh)/2.4
            if dx*dx+dy*dy<=1: g[y][x]='H'
    ey=int(round(cyh))-1
    g[ey][hx]='w'; g[ey][hx+1]='k'
    if ph in (0,1): g[int(round(cyh))][W-1]='r'
    return ["".join(r) for r in g]
coil=[
"............HHHH....",
"...........HHHHHH...",
"...........HwkHHH.r.",
"............HHHH....",
"....BBBBBBBBBHHB....",
"..BBBBBBBBBBBBBBBB..",
".BBBBddddddddddBBBB.",
".BBBdBBBBBBBBBBdBBB.",
".BBBBddddddddddBBBB.",
"..BBBBBBBBBBBBBBBB..",
"...BBBBBBBBBBBBBB...",
]
coil2=["...................."]+[l.replace(".r.","...") for l in coil[:-1]]
coil2[2]="............HHHH...."; coil2[3]="...........HwkHHH..."
strike=[
"..........................",
".........BBBBBBBB.....HHHH",
".....BBBBBBBBBBBBBBBHHHHHHH",
"...BBBBddddddddBBBBHHwkHHHHr",
"..BBBdBBBBBBBBdBBB..HHHHHH.",
"..BBBBddddddddBBBB....HHH..",
"...BBBBBBBBBBBBBB..........",
"....BBBBBBBBBBBB...........",
]
frames={'slither':[shade(slither(p),mats,tex=tex) for p in range(4)],
        'coiled':[shade(coil,mats,tex=tex),shade(coil2,mats,tex=tex)],
        'strike':[shade(strike,mats,tex=tex)]}
if __name__=='__main__':
    S=7; fs=[f for k in ('slither','coiled','strike') for f in frames[k]]
    W=sum(f.width*S+10 for f in fs); H=max(f.height for f in fs)*S
    im=Image.new('RGBA',(W,H),(74,150,70,255)); x=0
    for f in fs: im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),(x,0)); x+=f.width*S+10
    im.save('/tmp/claude-0/snake.png')
