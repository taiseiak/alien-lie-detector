extern float time;

const float cloudscale=3.;
const float speed=.001;
const float clouddark=.5;
const float cloudlight=.3;
const float cloudcover=.3;
const float cloudalpha=8.;
const float skytint=.5;
const int quantization=6;
const vec3 skycolour1=vec3(.2,.4,.6);
const vec3 skycolour2=vec3(.0863,.6039,1.);

const mat2 m=mat2(1.6,1.2,-1.2,1.6);

vec2 hash(vec2 p){
    p=vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
    return-1.+2.*fract(sin(p)*43758.5453123);
}

float noise(vec2 p){
    const float K1=.366025404;// (sqrt(3)-1)/2;
    const float K2=.211324865;// (3-sqrt(3))/6;
    vec2 i=floor(p+(p.x+p.y)*K1);
    vec2 a=p-i+(i.x+i.y)*K2;
    vec2 o=(a.x>a.y)?vec2(1.,0.):vec2(0.,1.);//vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
    vec2 b=a-o+K2;
    vec2 c=a-1.+2.*K2;
    vec3 h=max(.5-vec3(dot(a,a),dot(b,b),dot(c,c)),0.);
    vec3 n=h*h*h*h*vec3(dot(a,hash(i+0.)),dot(b,hash(i+o)),dot(c,hash(i+1.)));
    return dot(n,vec3(70.));
}

float voronoi(vec2 uv){
    vec2 g=floor(uv);
    vec2 f=fract(uv);
    float m_dist=1.;
    
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            vec2 lattice=vec2(x,y);
            vec2 point=hash(g+lattice);
            vec2 diff=lattice+point-f;
            float dist=dot(diff,diff);
            m_dist=min(m_dist,dist);
        }
    }
    return m_dist;
}

float fbm(vec2 n){
    float total=0.,amplitude=.1;
    for(int i=0;i<7;i++){
        total+=noise(n)*amplitude;
        n=m*n;
        amplitude*=.4;
    }
    return total;
}

vec3 quantize(vec3 color,int levels){
    float luminance=dot(color,vec3(.299,.587,.114));
    float quantized_luminance=floor(luminance*levels*1.1)/float(levels);
    vec3 adjusted_color=color*(quantized_luminance/luminance);
    
    return adjusted_color;
}

vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords){
    vec2 p=screen_coords.xy/love_ScreenSize.xy;
    vec2 uv=p*vec2(love_ScreenSize.x/love_ScreenSize.y,1.);
    vec2 ouv=uv;
    // float top_or_bottom=(.5-uv.y);
    // float left_or_right=(-sin(uv.x*3.1415)*.35);
    // uv.y+=top_or_bottom;
    // uv.x*=perspective;
    
    float t=time*speed;
    float q=fbm(uv*cloudscale*.5);
    
    // ridged noise shape
    float r=0.;
    uv*=cloudscale;
    uv.x-=q-t;
    float weight=.8;
    for(int i=0;i<8;i++){
        r+=abs(weight*noise(uv));
        uv=m*uv+t;
        weight*=.7;
    }
    
    // noise shape
    float f=0.;
    uv=p*vec2(love_ScreenSize.x/love_ScreenSize.y,1.);
    uv*=cloudscale;
    uv.x-=q-t;
    weight=.7;
    for(int i=0;i<8;i++){
        f+=weight*noise(uv);
        uv=m*uv+t;
        weight*=.6;
    }
    
    f*=r+f;
    
    // noise color
    float c=0.;
    t=time*speed*2.;
    uv=p*vec2(love_ScreenSize.x/love_ScreenSize.y,1.);
    uv*=cloudscale*2.;
    uv.x-=q-t;
    weight=.4;
    for(int i=0;i<7;i++){
        c+=weight*noise(uv);
        uv=m*uv+t;
        weight*=.6;
    }
    
    // noise ridge color
    float c1=0.;
    t=time*speed*3.;
    uv=p*vec2(love_ScreenSize.x/love_ScreenSize.y,1.);
    uv*=cloudscale*3.;
    uv.x-=q-t;
    weight=.4;
    for(int i=0;i<7;i++){
        c1+=abs(weight*noise(uv));
        uv=m*uv+t;
        weight*=.6;
    }
    
    c+=c1;
    
    vec3 skycolour=mix(skycolour2,skycolour1,p.y);
    vec3 cloudcolour=vec3(1.1,1.1,.9)*clamp((clouddark+cloudlight*c),0.,1.);
    
    f=cloudcover+cloudalpha*f*r;
    
    vec3 result=mix(skycolour2,clamp(skytint*skycolour2+cloudcolour,0.,1.),clamp(f+c,0.,1.));
    
    result=quantize(result,quantization);
    
    return vec4(result,1.);
}