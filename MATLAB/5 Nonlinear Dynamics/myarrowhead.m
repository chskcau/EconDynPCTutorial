% MATLAB, believe it or not, does not have a (good) built-in for drawing
% arrows or arrow heads. We draw our own.
function myarrowhead(x, y, angle, scale)

    xl = xlim;
    yl = ylim;
    xrange = xl(2) - xl(1);
    yrange = yl(2) - yl(1);
    xsize = xrange / 50 * scale;
    ysize = yrange / 50 * scale;

    coords = [0.5*xsize 0 ; -0.5*xsize +0.5*ysize ; -0.5*xsize -0.5*ysize];
    rotationMatrix = [ cos(angle) sin(angle) ; -sin(angle) cos(angle) ];
    coordsRotated = coords * rotationMatrix;

    patch(x + coordsRotated(:, 1), y + coordsRotated(:, 2), "black");

end
