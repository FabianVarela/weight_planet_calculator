#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uMouse;

out vec4 fragColor;

const float SEED = 5.8;

vec3 CAMERA = vec3(0, 0, -1);

const float PLANET_RADIUS = 0.75;

const vec3 ROTATION_AXIS = vec3(0.2, 1, 0);
const float ROTATION_SPEED = 0.25;

const float MOON1_RADIUS = 0.01;
const vec3 MOON1_POS = vec3(999, 999, 999);
const float MOON2_RADIUS = 0.01;
const vec3 MOON2_POS = vec3(999, 999, 999);
const float MOON3_RADIUS = 0.01;
const vec3 MOON3_POS = vec3(999, 999, 999);

const vec3 LAND_COLOR = vec3(0.55, 0.88, 0.88);
const vec3 JUNGLE_COLOR = vec3(0.42, 0.78, 0.80);
const vec3 DESERT_COLOR = vec3(0.65, 0.92, 0.90);
const vec3 SNOW_COLOR = vec3(0.78, 0.96, 0.95);

const float OCEAN_SIZE = 0.65;
const vec3 OCEAN_COLOR = vec3(0.40, 0.75, 0.82);

const vec3 ATMOSPHERE_COLOR = vec3(0.35, 0.82, 0.88);
const float ATMOSPHERE_DENSITY = 2.0;
const vec3 DAWN_COLOR = vec3(0.50, 0.85, 0.90);
const vec3 SUNSET_COLOR = vec3(0.30, 0.65, 0.80);
const vec3 CLOUD_COLOR = vec3(0.75, 0.95, 0.95);

const float AMBIENT_LIGHT = 0.20;
const float SHADOW_STRENGTH = 0.0;

const vec3 LIGHT1_POS = vec3(2, 12, -6);  // luz casi desde arriba
const vec4 LIGHT1_COLOR = vec4(0.85, 0.95, 1.00, 1.10);
const vec3 LIGHT2_POS = vec3(-6, 4, 6);
const vec4 LIGHT2_COLOR = vec4(0.40, 0.80, 0.90, 0.20);

const int TYPE = 1;

const float RING_INNER = 1.20;
const float RING_OUTER = 1.80;
const vec3 RING_COLOR_A = vec3(0.25, 0.28, 0.30);
const vec3 RING_COLOR_B = vec3(0.20, 0.22, 0.25);
const vec3 RING_COLOR_C = vec3(0.28, 0.30, 0.32);

const float PI = 3.14159265;
const float TAU = 6.2831853;

float hash12(vec2 p, float scale) {
    p = mod(p, scale);
    p.y += SEED;
    return fract(sin(dot(p, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p, float scale) {
    p *= scale;
    vec2 f = fract(p);
    p = floor(p);
    return mix(mix(hash12(p, scale),
                   hash12(p + vec2(1, 0), scale), f.x),
               mix(hash12(p + vec2(0, 1), scale),
                   hash12(p + vec2(1, 1), scale), f.x), f.y);
}

float fbm(vec2 p, float scale, int octaves) {
    float s = 0.0, m = 0.0, a = 1.0;
    for (int i = 0; i < octaves; i++) {
        s += a * noise(p, scale);
        m += a;
        a *= 0.6;
        scale *= 2.0;
    }
    return s / m;
}

float swirly_fbm(vec2 p, float scale, int octaves) {
    p -= uTime * 0.004;
    float s = 0.0, m = 0.0, a = 1.0;
    for (int i = 0; i < octaves; i++) {
        s += a * noise(p + uTime * 0.004 * a, scale);
        m += a;
        a *= 0.6;
        scale *= 2.0;
        p += vec2(cos(s * TAU), sin(s * TAU)) / scale * 0.4;
    }
    return s / m;
}

vec2 hash22(vec2 p, float scale) {
    p = mod(p, scale);
    p.y += SEED;
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

float crater_noise(vec2 p, float scale) {
    p *= scale;
    vec2 f = fract(p);
    p = floor(p);
    float va = 0., wt = 0.;
    for (int i = -1; i <= 1; i++)
    for (int j = -1; j <= 1; j++) {
        vec2 g = vec2(i, j);
        vec2 o = hash22(p + g, scale);
        float d = distance(f - g, o);
        float w = exp(-4. * d);
        va += w * sin(TAU * sqrt(max(d, 0.06)));
        wt += w;
    }
    return abs(va / wt);
}

float crater_fbm(vec2 x) {
    float craters = crater_noise(x, 7.0) * 0.6 + crater_noise(x, 20.0) * 0.2;
    return 1.0 - (craters + fbm(x, 48.0, 3) * 0.35) * 0.4;
}

vec3 lookat(vec3 v) {
    vec3 f = normalize(CAMERA);
    vec3 s = normalize(vec3(-f.z, 0, f.x));
    return v * mat3(s, cross(s, f), -f);
}

vec3 rot_axis(vec3 v, vec3 axis, float angle) {
    vec4 q = vec4(cos(angle * 0.5), axis * sin(angle * 0.5));
    return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

vec3 get_norm(vec2 uv, float z) {
    vec2 _m = vec2(uMouse) / uResolution * 2.0 - 1.0;
    vec3 n = rot_axis(vec3(uv, z), normalize(ROTATION_AXIS),
                      (_m.x * 16.0 + uTime) * ROTATION_SPEED);
    return lookat(n);
}

vec2 mercator(vec3 n) {
    return vec2(atan(n.z, n.x) * 0.5, acos(-n.y)) / PI;
}

float ray_sphere_intersect(vec3 ro, vec3 rd, vec3 so, float sr) {
    float a = dot(rd, rd);
    vec3 so_ro = ro - so;
    float b = 2.0 * dot(rd, so_ro);
    float c = dot(so_ro, so_ro) - (sr * sr);
    if (b * b - 4.0 * a * c < 0.0) return -1.0;
    return (-b - sqrt(b * b - 4.0 * a * c)) / (2.0 * a);
}

vec4 planet(vec2 uv) {
    float len = length(uv);
    float f = fwidth(len);
    if (len > 1.0 - f * 0.3) return vec4(0);
    float z = -sqrt(0.999 - len * len);
    vec3 norm = get_norm(uv, z);
    vec2 muv = mercator(norm);
    if (TYPE == 1) {
        muv.y += fbm(muv, 16.0, 4) * 0.125;
        muv.y *= 5.0;
    }
    float smooth_edge = smoothstep(1.0, 1.0 - f * 2.0, len);
    f *= 2.0;
    vec3 col = vec3(0);
    if (TYPE == 1) {
        float continent = fbm(vec2(muv.y, 0), 2.0, 7);
        float temp = fbm(muv * 3.0 + vec2(31.33), 1.0, 4);
        float humid = fbm(muv * 3.0 - vec2(54.1), 1.0, 4);
        float sqrt_continent = sqrt(continent);
        float land = smoothstep(f, 0.0, OCEAN_SIZE - continent);
        col += LAND_COLOR;
        col = mix(col, DESERT_COLOR, smoothstep(0.25, 0.1, humid));
        col = mix(col, JUNGLE_COLOR, smoothstep(0.1, 0.3, humid) * smoothstep(0.3, 0.4, temp));
        col = mix(col, SNOW_COLOR, smoothstep(0.3, 0.2, temp));
        col *= sqrt_continent * land * 1.2 * smoothstep(1.0, 0.99, abs(norm.y));
        col += (1.0 - continent) * smoothstep(OCEAN_SIZE, OCEAN_SIZE - f, continent) * OCEAN_COLOR;
        col.rgb *= sqrt(1.0 + 0.1 * cos(sqrt(continent) * 512.0));
    }
    return vec4(col, smooth_edge);
}

void main() {
    float min_res = min(uResolution.x, uResolution.y);
    vec2 uv = (FlutterFragCoord().xy * 2.0 - uResolution) / min_res;
    uv.y = -uv.y; // Invert

    float len = length(uv);
    const float RING_SQUISH = 0.15;

    float ring_r = length(vec2(uv.x, uv.y / RING_SQUISH));
    float t = (ring_r - RING_INNER) / (RING_OUTER - RING_INNER);

    float ell_out = (uv.x * uv.x) / (RING_OUTER * RING_OUTER)
    + (uv.y * uv.y) / (RING_OUTER * RING_OUTER * RING_SQUISH * RING_SQUISH);
    float ell_in = (uv.x * uv.x) / (RING_INNER * RING_INNER)
    + (uv.y * uv.y) / (RING_INNER * RING_INNER * RING_SQUISH * RING_SQUISH);
    bool in_ring = (ell_out <= 1.0 && ell_in >= 1.0);

    vec4 ring_col = vec4(0.0);
    if (in_ring && t >= 0.0 && t <= 1.0) {
        float bn = noise(vec2(t * 40.0, 0.5), 1.0) * 0.3
        + noise(vec2(t * 120.0, 0.5), 1.0) * 0.15;

        float density = 0.0;
        if (t < 0.15) density = smoothstep(0.0, 0.15, t) * 0.25;
        else if (t < 0.35) density = 0.15 + bn * 0.08;
        else if (t < 0.50) density = 0.05 + bn * 0.05;
        else if (t < 0.65) density = 0.20 + bn * 0.08;
        else density = 0.12 + bn * 0.06;
        density = clamp(density, 0.0, 1.0)
        * smoothstep(1.00, 0.94, ell_out)
        * smoothstep(1.00, 1.12, ell_in);

        vec3 rc = RING_COLOR_A;
        rc *= LIGHT1_COLOR.rgb * 0.80;
        ring_col = vec4(rc, density * 0.98);
    }

    float planet_shadow_on_rings = smoothstep(1.08, 0.92, len)
    * smoothstep(-0.02, 0.08, uv.y);
    ring_col.rgb *= (1.0 - planet_shadow_on_rings * 0.0);

    bool on_planet = (len <= 1.3);
    vec4 planetCol = vec4(0.0);

    if (on_planet) {
        vec4 p = planet(uv / PLANET_RADIUS);
        float z = -sqrt(max(0.0, 0.999 - min(len, 0.999) * min(len, 0.999)));
        vec3 norm = lookat(vec3(uv, z));
        vec3 light = vec3(0.0);
        float shadow = 1.0;

        #define S(lp, mp, mr, n)\
            { float dist = ray_sphere_intersect(lp, n, mp, mr); \
 if (dist >= 0.0)\
                shadow *= 1.0 - SHADOW_STRENGTH\
 * smoothstep(0.0, 0.5, - (dist - distance(mp, lp)) / mr); }

        vec3 n1 = normalize(norm - LIGHT1_POS);
        S(LIGHT1_POS, MOON1_POS, MOON1_RADIUS, n1)
        S(LIGHT1_POS, MOON2_POS, MOON2_RADIUS, n1)
        S(LIGHT1_POS, MOON3_POS, MOON3_RADIUS, n1)
        vec3 n2 = normalize(norm - LIGHT2_POS);
        S(LIGHT2_POS, MOON1_POS, MOON1_RADIUS, n2)
        S(LIGHT2_POS, MOON2_POS, MOON2_RADIUS, n2)
        S(LIGHT2_POS, MOON3_POS, MOON3_RADIUS, n2)

        light += max(0.0, dot(norm, normalize(LIGHT1_POS)) * 0.8 + 0.2)
        * LIGHT1_COLOR.rgb * LIGHT1_COLOR.a;
        light += max(0.0, dot(norm, normalize(LIGHT2_POS)) * 0.8 + 0.2)
        * LIGHT2_COLOR.rgb * LIGHT2_COLOR.a;

        p.rgb *= shadow * light + AMBIENT_LIGHT;
        planetCol = clamp(p, 0.0, 1.0);
    }

    float glow_len = length(vec2(uv.x, uv.y / RING_SQUISH));
    float glow = exp(-max(0.0, glow_len - 0.98) * 18.0);
    glow *= smoothstep(0.3, 0.0, abs(uv.y));
    vec3 glow_col = ATMOSPHERE_COLOR * LIGHT1_COLOR.rgb * LIGHT1_COLOR.a * glow * 0.9;

    float behind = smoothstep(-0.02, 0.04, uv.y);
    float front = 1.0 - behind;

    fragColor = vec4(0.0, 0.0, 0.0, 1.0);

    if (!on_planet)
    fragColor.rgb += glow_col;

    if (in_ring)
    fragColor.rgb = mix(fragColor.rgb, ring_col.rgb, ring_col.a * behind);

    if (on_planet)
    fragColor.rgb = mix(fragColor.rgb, planetCol.rgb, planetCol.a);

    if (in_ring)
    fragColor.rgb = mix(fragColor.rgb, ring_col.rgb, ring_col.a * front);

    fragColor.a = 1.0;
}
