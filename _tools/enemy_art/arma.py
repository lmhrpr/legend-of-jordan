from px import shade
from PIL import Image
import math
SH=[(46,34,36),(82,60,56),(124,94,78),(166,134,102),(206,178,136),(236,214,170)]
SK=[(104,60,58),(156,98,86),(204,144,122),(236,190,164)]
mats={'S':SH,'F':SK,'E':SK,'L':[(90,54,50),(136,86,76),(182,126,106)],'k':[(16,12,12)],'w':[(250,246,236)],'N':[(70,40,40)],'C':[(230,220,200)]}
def tex(m,x,y,i,h):
    if m=='S':
        if x%3==0: i-=1
        if (x%3==1) and (y%2==0) and h>=2: i+=1
        if y>=8: i-=1
    return i
top=[
"..........SSSSSSSS..........",
".......SSSSSSSSSSSSSS.......",
".....SSSSSSSSSSSSSSSSSS.....",
"....SSSSSSSSSSSSSSSSSSSS..EE",
"...SSSSSSSSSSSSSSSSSSSSSSEEE",
"...SSSSSSSSSSSSSSSSSSSSSSFEE",
"..SSSSSSSSSSSSSSSSSSSSSSSFFFF",
"..SSSSSSSSSSSSSSSSSSSSSSSFFwkF",
".FSSSSSSSSSSSSSSSSSSSSSSSFFkkFF",
"FF.SSSSSSSSSSSSSSSSSSSSSSFFFFFFN",
]
legA=["F....LLL.........LLL....FFFFFF..", ".....LL..........LL.............", "....LCLC........LCLC............"]
legB=["F.....LLL.........LLL...FFFFFF..", "......LL...........LL...........", ".....CLCL.........CLCL.........."]
walk=[shade(top+legA,mats,tex=tex),shade(top+legB,mats,tex=tex)]
def ball(ph,D=15):
    rows=[]
    for y in range(D):
        r=""
        for x in range(D):
            dx,dy=x-(D-1)/2,y-(D-1)/2
            r+= "S" if dx*dx+dy*dy<=((D-1)/2+0.3)**2 else "."
        rows.append(r)
    a=ph*math.pi/4
    def t2(m,x,y,i,h):
        dx,dy=x-(D-1)/2,y-(D-1)/2
        u=dx*math.cos(a)+dy*math.sin(a)
        if int(math.floor(u+20))%3==0: i-=2          # bands, turning as it rolls
        elif int(math.floor(u+20))%3==1 and h>=2 and (int(dx*math.sin(a)-dy*math.cos(a)+20))%2==0: i+=1
        return i
    return shade(rows,mats,tex=t2)
frames={'walking':walk,'rolled up, rolling':[ball(p) for p in range(4)]}
if __name__=='__main__':
    S=6; fs=[f for k in frames for f in frames[k]]
    W=sum(f.width*S+10 for f in fs); H=max(f.height for f in fs)*S
    im=Image.new('RGBA',(W,H),(74,150,70,255)); x=0
    for f in fs: im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),(x,H-f.height*S)); x+=f.width*S+10
    im.save('/tmp/claude-0/arma.png')
