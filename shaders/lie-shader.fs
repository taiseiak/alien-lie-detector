// Inspired by https://www.youtube.com/watch?v=3CycKKJiwis
// https://www.youtube.com/watch?v=KGJUl8Teipk

#define S(a,b,t)smoothstep(a,b,t)

extern float time;
// from 0 to 1
extern float lieness;
// from 0 to 1
extern float nervousness;
// More than 1
extern float anger;

float DistLine(vec2 p,vec2 a,vec2 b){
    vec2 pa=p-a;
    vec2 ba=b-a;
    float t=clamp(dot(pa,ba)/dot(ba,ba),0.,1.);
    return length(pa-ba*t);
}

// Creates a random number that is agnostic to what hardware it's running on
float N21(vec2 p){
    p=fract(p*vec2(233.34,851.73));
    p+=dot(p,p+23.45);
    return fract(p.x*p.y);
}

vec2 N22(vec2 p){
    float n=N21(p);
    return vec2(n,N21(p+n));
}

vec2 GetPos(vec2 id,vec2 offset){
    vec2 n=N22(id+offset)*time;
    return offset+sin(n)*.4;
}

float Line(vec2 p,vec2 a,vec2 b){
    float d=DistLine(p,a,b);
    float m=S(.015,.01,d);
    float d2=length(a-b);
    m*=S(1.1,.8,d2)*.5+S(.05,.03,abs(d2-.75));
    return m;
}

float Layer(vec2 uv){
    float m=0;
    vec2 gv=fract(uv)-.5;
    vec2 id=floor(uv);
    
    // vec2 p=GetPos(id);
    
    // float d=length(gv-p);
    // m=S(.1,.03,d);
    
    vec2 p[9];
    int i=0;
    for(float y=-1.;y<=1;y++){
        for(float x=-1.;x<=1;x++){
            p[i++]=GetPos(id,vec2(x,y));
        }
    }
    float t=time*10.;
    for(int i=0;i<9;i++){
        m+=Line(gv,p[4],p[i]);
        
        vec2 j=(p[i]-gv)*30.;
        float sparkle=1./dot(j,j);
        
        m+=sparkle*(sin(t+fract(p[i].x)*10.)*.5+.5);
    }
    m+=Line(gv,p[1],p[3]);
    m+=Line(gv,p[1],p[5]);
    m+=Line(gv,p[3],p[7]);
    m+=Line(gv,p[5],p[7]);
    
    return m;
}

vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords){
    vec2 uv=(screen_coords-.5*love_ScreenSize.xy)/love_ScreenSize.y-.3;
    // uv*=10.;
    float m=0;
    
    float gradient=uv.y;
    
    float t=time*.4*anger;
    // float s=sin(t);
    // float c=cos(t);
    // mat2 rot=mat2(c,-s,s,c);
    // uv*=rot;
    // float size=10.;
    // m+=Layer(uv*size*.5*20.*lieness);
    for(float i=0.;i<=1.;i+=1./8.){
        float z=fract(i);
        float size=mix(10.,.5,z);
        float fade=S(0.,.5,z)*S(1.,.8,z);
        m+=Layer(uv*size*mix(.5,1.5,lieness)+i*20.)*fade;
    }
    
    vec3 base=sin(5.*vec3(lieness,nervousness,.234))*.4+.6;
    vec3 col=m*base;
    gradient*=sin(t*nervousness)*.7+.3;
    col+=gradient*base;
    
    return vec4(col,1.);
}