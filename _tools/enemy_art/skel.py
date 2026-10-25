from px import shade, flip
from PIL import Image
BONE=[(112,104,92),(160,152,134),(204,198,178),(236,232,214),(252,250,240)]
mats={'B':BONE,'K':[(20,16,18)],'D':[(70,62,58)],'T':[(250,248,236)],'r':[(200,40,40)]}
body=[
"......BBBBBB......",
".....BBBBBBBB.....",
"....BBBBBBBBBB....",
"....BKKKBBKKKB....",
"....BKrKBBKrKB....",
".....BBBBBBBB.....",
"......BBDDBB......",
"......TBTBTB......",
".......BBBB.......",
"........BB........",
"....BBBBBBBBBB....",
"...BBB.BBBB.BBB...",
"...B..BDBBDB..B...",
"...B..BBBBBB..B...",
"...B..BDBBDB..B...",
"..BB...BBBB...BB..",
"..B.....BB.....B..",
"..BB...BBBB...BB..",
"......BB..BB......",
"......B....B......",
"......B....B......",
"......B....B......",
".....BB....BB.....",
]
def legs(rows, step):
    rows=list(rows)
    if step:
        rows[19]="......B.....B....."; rows[20]=".....B......B....."; rows[21]=".....B.......B...."; rows[22]="....BB.......BB..."
    return rows
SW={'S':[(120,130,146),(176,186,200),(226,234,242)],'G':[(150,110,40),(214,170,70)],'h':[(80,50,30),(120,80,50)],
    'W':[(90,58,34),(132,90,54),(170,120,72)],'M':[(110,110,120),(170,170,182),(214,214,224)],'P':[(150,150,160),(220,220,230),(250,250,255)]}
sword=["..S.",".SS.",".SS.",".SS.",".SS.",".SS.",".SS.","GGGG",".hh.",".hh.",".GG."]
spear=[".P.",".P.","PPP","PPP",".P.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W.",".W."]
shield=["..MMMMM..",".MWWWWWM.","MWWWWWWWM","MWWWMWWWM","MWWMMMWWM","MWWWMWWWM","MWWWWWWWM",".MWWWWWM.","..MMMMM.."]
def make(step, sword_=False, spear_=False, shield_=False):
    im=shade(legs(body,step),mats,bias={'B':0.15})
    canvas=Image.new('RGBA',(im.width+8,im.height+4),(0,0,0,0)); canvas.alpha_composite(im,(4,4))
    if spear_: canvas.alpha_composite(shade(spear,SW),(17,0))
    if sword_: canvas.alpha_composite(shade(sword,SW),(17,11))
    if shield_: canvas.alpha_composite(shade(shield,SW),(0,13))
    return canvas
variants={'no weapon':{},'sword':{'sword_':True},'throwing spear':{'spear_':True},
          'shield and sword':{'shield_':True,'sword_':True},'shield and spear':{'shield_':True,'spear_':True}}
frames={k:[make(s,**v) for s in (0,1)] for k,v in variants.items()}
if __name__=='__main__':
    S=6; fs=[f for k in frames for f in frames[k]]
    W=sum(f.width*S+10 for f in fs); H=max(f.height for f in fs)*S
    im=Image.new('RGBA',(W,H),(74,150,70,255)); x=0
    for f in fs: im.alpha_composite(f.resize((f.width*S,f.height*S),Image.NEAREST),(x,0)); x+=f.width*S+10
    im.save('/tmp/claude-0/skel.png')
