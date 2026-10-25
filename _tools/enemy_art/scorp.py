from px import shade
from PIL import Image
CAR=[(70,24,20),(112,40,30),(158,66,42),(202,104,62),(236,152,98)]
LEG=[(64,26,22),(104,44,32),(146,70,48)]
mats={'B':CAR,'T':CAR,'P':CAR,'L':LEG,'k':[(14,10,10)],'s':[(250,220,110)]}
def tex(m,x,y,i,h):
    if m=='B' and x%3==0 and x<15: i-=1       # the plates of its back
    if m=='T' and (x+y)%2==0: i-=1           # tail segments
    return i
walk=[[
"........TTTTT.............",
".......TT...TT............",
"......TT.....Ts...........",
".....TT.......s...........",
".....T....................",
".....TT...........PPP.....",
"......TBBBBBBBB..PP..PP...",
".....BBBBBBBBBBBPP........",
"....BBBBBBBBBBBBBBk.......",
"....BBBBBBBBBBBBBBB.......",
".....BBBBBBBBBBBPP........",
"......BBBBBBBBB..PP..PP...",
"...L..L..L..L.....PPP.....",
"..L..L..L..L..............",
],[
"........TTTTT.............",
".......TT...TT............",
"......TT.....Ts...........",
".....TT.......s...........",
".....T....................",
".....TT...........PPP.....",
"......TBBBBBBBB..PP..PP...",
".....BBBBBBBBBBBPP........",
"....BBBBBBBBBBBBBBk.......",
"....BBBBBBBBBBBBBBB.......",
".....BBBBBBBBBBBPP........",
"......BBBBBBBBB..PP..PP...",
"....L..L..L..L....PPP.....",
"...L..L..L..L.............",
]]
sting=[
"..........................",
"..........TTTT............",
".........TT..TT...........",
"........TT....TTs.........",
".......TT........s........",
".....TT...........PPP.....",
"......TBBBBBBBB..PP..PP...",
".....BBBBBBBBBBBPP........",
"....BBBBBBBBBBBBBBk.......",
"....BBBBBBBBBBBBBBB.......",
".....BBBBBBBBBBBPP........",
"......BBBBBBBBB..PP..PP...",
"...L..L..L..L.....PPP.....",
"..L..L..L..L..............",
]
SAND=[(150,112,72),(190,150,100),(222,188,136),(244,220,172)]
mm={'D':SAND,'g':[(120,88,56)]}
mound=[[
"..................",
"..................",
".......DDDD.......",
".....DDDDDDDD.....",
"...DDDDDDDDDDDD...",
"..DDDDDDDDDDDDDDD.",
],[
"..................",
"........DD........",
"......DDDDDD......",
"....DDDDDDDDDD....",
"...DDDDDDDDDDDDD..",
"..DDDDDDDDDDDDDDD.",
]]
emerge=[
"......g......g....",
"...g....TT..g.....",
"........TTs.......",
"....DDDBBBBDDD....",
"..DDDDBBBBBBDDDD..",
"..DDDDDDDDDDDDDDD.",
]
mm2={**mm,**{'T':CAR,'B':CAR,'s':[(250,220,110)]}}
frames={'scuttling':[shade(f,mats,tex=tex) for f in walk],'sting':[shade(sting,mats,tex=tex)],
        'burrowed':[shade(f,mm,inner_lines=False) for f in mound],'popping up':[shade(emerge,mm2)]}
if __name__=='__main__':
    S=7; fs=[f for k in frames for f in frames[k]]
    W=sum(f.width*S+10 for f in fs); H=max(f.height for f in fs)*S
    im=Image.new('RGBA',(W,H),(74,150,70,255)); x=0
    for f in fs: im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),(x,H-f.height*S)); x+=f.width*S+10
    im.save('/tmp/claude-0/scorp.png')
