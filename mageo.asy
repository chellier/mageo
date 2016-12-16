/*
Ensemble de macros de géométrie pour le logiciel Asymptote
C. Grospellier (chellier)
*/
import graph;
import geometry;
import trembling;

// un trait perpendiculaire à une direction
void dott(picture pic=currentpicture, Label L="", pair z, align align=NoAlign, pair dir, real size=1, pen p=currentpen)
{
  Label L=L.copy();
  L.position(z);
  L.align(align,E);
  L.p(p);
  pair z=Scale(pic,z);
  pic.add(new void (frame f, transform t) {
      pair tz=t*z;
      draw(f,tz-unit(dir)*I*size*Ticksize--tz--tz+unit(dir)*I*size*Ticksize,p);
    });
  pic.addPoint(z,p);
  pic.addPoint(z,unit(dir)*I*size*Ticksize,p);
  add(pic,L);
}

// une croix tournée d'un certain angle
void dotc(picture pic=currentpicture, Label L="", pair z, align align=NoAlign, real angle=0, real size=1, pen p=currentpen)
{
   real size=size*Ticksize;
   marker croix=marker(scale(size)*rotate(angle)*cross(4),p);
   draw(pic,L,z,align,p,croix);
}

// accolade
void brace(picture pic = currentpicture, Label L="", pair A, pair B,
    bool rotated = true, real offset=3mm, pen pb = currentpen, pen pL=pb){
    pair C=(A+B)/2;
    path ab=A--B;
    transform Tp = shift(-offset * unit(B - A) * I), Tl=shift(-1mm * unit(B - A) * I);
    pic.add(new void(frame f, transform t) {
       picture opic;
       path G = Tp * t * ab;
       real x=abs(t*B-t*A);
       transform id = identity();
       transform T = rotated ? Tl*rotate(degrees(B-A)) : Tl;
       label(opic,
          Tp*rotate(degrees(B-A))*format("$\underbrace{\hspace {%f cm}}$",x/cm),
          t*C,pb);
       draw(opic,Label(T*L,pL),G,invisible);
       add(f, opic.fit());
    }, true);
}

// ----- marquage de distance -----
// marquage à côté de la flèche
void dist(picture pic = currentpicture,Label L="", pair A, pair B,
            bool rotated = true, real offset=3mm, pen p=currentpen,
            arrowbar arrow = Arrows(HookHead,1.5mm)){
    path ab=A--B;
    transform Tp = shift(-offset * unit(B - A) * I);
    pic.add(new void(frame f, transform t) {
      picture opic;
      path G = Tp * t * ab;
      transform id = identity();
      transform T = rotated ? rotate(degrees(B - A)) : id;
      draw(opic,T * L,G,p,arrow); 
      add(f, opic.fit());
    }, true);
}

// marquage sur la flèche à main levée
void distunTR(picture pic = currentpicture,Label L="", pair A, pair B,
              bool rotated = true, real offset=3mm, pen p=currentpen, tremble tr,
              arrowbar arrow = Arrows(HookHead,1.5mm)){
    path ab=A--B;
    transform Tp = shift(-offset * unit(B - A) * I);
    pic.add(new void(frame f, transform t) {
      picture opic;
      path G = Tp * t * ab;
      transform id = identity();
      transform T = rotated ? rotate(degrees(B - A)) : id;
      draw(opic,Label(T * L,align=Center,filltype=UnFill),tr.deform(G),p,arrow);
      add(f, opic.fit());
    }, true);
}
// marquage à côté de la flèche à main levée
void distTR(picture pic = currentpicture,Label L="", pair A, pair B,
            bool rotated = true, real offset=3mm, pen p=currentpen, tremble tr,
            arrowbar arrow = Arrows(HookHead,1.5mm)){
    path ab=A--B;
    transform Tp = shift(-offset * unit(B - A) * I);
    pic.add(new void(frame f, transform t) {
      picture opic;
      path G = Tp * t * ab;
      transform id = identity();
      transform T = rotated ? rotate(degrees(B - A)) : id;
      draw(opic,T * L,tr.deform(G),p,arrow); 
      add(f, opic.fit());
    }, true);
}

// distance à main levée
void distanceTR(picture pic = currentpicture, Label L = "", point A, point B,
              bool rotated = true, real offset = 3mm,
              pen p = currentpen, pen joinpen = invisible, tremble tr,
              arrowbar arrow = Arrows(NoFill))
{ pair A = A, B = B;
  path g = A--B;
  transform Tp = shift(-offset * unit(B - A) * I);
  pic.add(new void(frame f, transform t) {
      picture opic;
      path G = Tp * t * g;
      transform id = identity();
      transform T = rotated ? rotate(degrees(B - A)) : id;
      Label L = L.copy();
      L.align(L.align, Center);
      if(abs(ypart((conj(A - B) * L.align.dir))) < epsgeo && L.filltype == NoFill)
        L.filltype = UnFill(1);
      draw(opic, T * L, tr.deform(G), p, arrow, Bars, PenMargins);
      pair Ap = t * A, Bp = t * B;
      draw(opic, tr.deform(Ap--Tp * Ap)^^tr.deform(Bp--Tp * Bp), joinpen);
      add(f, opic.fit());
    }, true);
  pic.addBox(min(g), max(g), Tp * min(p), Tp * max(p));
}

// angle droit à main levée
void perpendicularmarkTR(picture pic = currentpicture, point z,
                       explicit pair align,
                       explicit pair dir = E, real size = 0,
                       pen p = currentpen,
                       margin margin = NoMargin,
                       filltype filltype = NoFill, tremble tr)
{
  p = squarecap + p;
  if(size == 0) size = perpfactor * 3mm + sqrt(1 + linewidth(p)) - 1;
  frame apic;
  pair d1 = size * align * unit(dir) * dir(-45);
  pair d2 = I * d1;
  path g = tr.deform(d1--d1 + d2--d2);
  g = margin(g, p).g;
  if(filltype != NoFill) filltype.fill(apic, (relpoint(g, 0) - relpoint(g, 0.5)+
                                             relpoint(g, 1))--g--cycle, p + solid);
  draw(apic, tr.deform(g), p);
  add(pic, apic, locate(z));
}

void markrightangleTR(picture pic = currentpicture, point A, point O,
                    point B, real size = 0, pen p = currentpen,
                    margin margin = NoMargin,
                    filltype filltype = NoFill, tremble tr)
{
  pair Ap = A, Bp = B, Op = O;
  pair dir = Ap - Op;
  real a1 = degrees(dir);
  pair align = rotate(-a1) * unit(dir(Op--Ap, Op--Bp));
  if (margin == NoMargin)
    margin = TrueMargin(linewidth(currentpen)/2, linewidth(currentpen)/2);
  perpendicularmarkTR(pic = pic, z = O, align = align,
                    dir = dir, size = size, p = p,
                    margin = margin, filltype = filltype, tr);
}

