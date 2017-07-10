function [handle] = trackplotsst(dt, lat, lon, sst, LATMNMX, LONMNMX, TMNMX),% [handle] = trackplotsst(dt, lat, lon, sst, LATMNMX, LONMNMX, TMNMX)% [fgh] = trackplotsst(dt, lat, lon, sst, [10, 45]', [140, 220]', [10,40]')% Plot any variable other than sst. %input% lat = latitude vector, nx1% lon = longitude vector, nx1% sst = temp nx1% LATMNMX = [min; max] 2x1, [0,0] => self scale% LONMNMX = ditto% TMNMX = ditto for tempglobal DATAPATH SERIESaddpath('/Users/rmr/swmain/matlab/crusty/m_map')D2R = pi/180;handle=0;%PUT LON IN THE RANGE 0 TO 360lon = CompassCheck(lon);LONMNMX = CompassCheck(LONMNMX);%================% MAP SCALES%================if LATMNMX(1)==0 & LATMNMX(2)==0, 	latmin = min(lat); latmax = max(lat);	D = (latmax-latmin);	if D > 20,		scle = 5;	elseif D > 10,		scle = 2;	elseif D > 4,		scle = 1;	elseif D > 1,		scle = .5;	else		scle = .2;	end	latmin = latmin - scle;	latmax = latmax + scle;else	latmin=LATMNMX(1); latmax=LATMNMX(2);endif LONMNMX(1)==0 & LONMNMX(2)==0,	lonmin = min(lon); lonmax = max(lon);	D = (lonmax-lonmin);	if D > 20,		scle = 5;	elseif D > 10,		scle = 2;	elseif D > 4,		scle = 1;	elseif D > 1,		scle = .5;	else		scle = .2;	end	lonmin = lonmin-scle;	lonmax = lonmax + scle;else	lonmin=LONMNMX(1); lonmax=LONMNMX(2);end%===============% TEMPERATURE SCALE%===============if TMNMX(1)==0 & TMNMX(2)==0,	tmin=min(sst);  tmax=max(sst);else tmin=TMNMX(1); tmax=TMNMX(2);end% CLEAN LAT LON AND SST[xc,ix]=CleanSeries(lat,[latmin,latmax]);ix=find(isnan(lat));[xc,iy]=CleanSeries(lon,[lonmin,lonmax]);iy=find(isnan(lon));[xc,iz]=CleanSeries(sst,[tmin,tmax]);iz=find(isnan(sst));ia=union(ix,iy);ia=union(ia,iz);lat(ia)=[]; lon(ia)=[]; sst(ia)=[];  dt(ia)=[];% TEMP DIFFERENCEfprintf('Tmin=%.1f, Tmax=%.1f\n',tmin,tmax);D = (tmax-tmin);fprintf('TEMP DIFF = %.2f\n',D);%d = 1, 2, 5, 10;  sp = ceil(D/4);fprintf('Spread = %.1f\n',sp);t1=floor(tmin/sp)*sp;t2=t1+5*sp;fprintf('t1=%.1f, t2=%.1f\n',t1,t2);ytl=sprintf('%.0f',t1);for i=2:5,	ytl = str2mat(ytl, sprintf('%.0f',t1+(i-1)*sp));end% 1--65, 64 divisions color = 1 + 64 * (t-tmin) / (tmax-timn)% 5 divisionsytk = [1 15 30 45 65];xt = str2num(ytl); 						% convert to numberstemplim = [xt(1); xt(end)];dely = 0.1;delx = 0.01 * (lonmax-lonmin);%=================% FIGURE%=================% Set up the figure and axes at the start, so that the vector lengths% will come out right when the figure is printed:fg = figure;set(fg,'position',[10,200,900,600],'papersize',[10,5]);orient tall% Main axes, for the map.% ha1 = axes;% pos = get(ha1,'position');% pos% pos1 = pos;% pos1(1) = pos1(1);% pos1(2) = pos1(2) + 0.1;% pos1(3) = pos1(3) - 0.1;% pos1(4)= pos1(4);% pos1% set(ha1,'units','normalized','position',pos1)% get(ha1)% return%=================% COLORMAP%=================colormap('default');cb=colorbar; set(cb,'ytick',ytk);set(cb,'yticklabel',ytl);dtstart = dt(1);  dtend = dt(end);% NUMBER OF DAYS TO SKIP BETWEEN DAY LABELSndaylabmax = 10;nskip = max(1, fix((dtend - dtstart)/ndaylabmax)+1);fprintf('Skip %d days between labels\n',nskip);% projectionm_proj('mercator','longitudes',[lonmin, lonmax],'latitudes',[latmin, latmax]);%pos = get(gca,'position');%pos(1)=pos(1)+.08;%pos(3)=pos(3)+0.05;%===================% draw the coast line%===================m_coast('patch',[.8 .8 .8]);%m_gshhs_m('patch',[.8 .8 .8]);% gridm_grid('fontname','helvetica','fontsize',12,'box','fancy',...	'linewidth',.5, 'linespec','-');set(gcf,'color','w');%===================% TRACK LINE%===================disp('plot track');clr = colormap;% isst is a color number 0-63 for all pointsisst = round(1 + 63*(sst-templim(1))/diff(templim));ix = find(isst<1); if length(ix)>0, isst(ix)=1; endix = find(isst>64); if length(ix)>0, isst(ix)=64; end%===================% Better if we plot each point by point%===================dlat = (latmax-latmin)/800;for i = 1:length(dt),	dlon = (lonmax-lonmin)/800  ./ cos(lat(i)*D2R);	m_line([lon(i)-dlon,lon(i)+dlon],[lat(i)-dlat,lat(i)+dlat],'linewi',3,'color',clr(isst(i),:) );end% START POINTtx = m_line(lon(1),lat(1)); set(tx,'marker','o','markerfacecolor','k','markeredgecolor','k');% labelstr = sprintf('START');txstart = m_text(lon(1), lat(1)-delx, str, 'fontweight','bold','fontsize',10, 'color','black');set(txstart,'verticalalignment','top','horizontalalignment','center');nmarkdays = 3;% all jdays% ALL JDAYS IN THIS SERIESdtx = fix(dt(1))+1:nmarkdays:fix(dt(end))';clr = colormap;%================% CONTINUOUS GROUPS% FIND GROUPS OF FIXES SEPARATED BY GAPS OF > 24 HRS% dt, lat, lon are all positions. % [i1 i2] is the matrix of start/stop positions in blocks.% example:%  first "continuous" group begins at dt(i1(1)),lat(i1(1)),lon(i1(1)) and ends at dt(i2(1)),lat(i2(1)),lon(i2(1))%================maxgap=24;ix = find( diff(dt)*24 > maxgap );if length(ix) > 0,	i1 = 1;	i1 = [i1; ix+1];	i2 = [ix; length(dt)];	fprintf('There are %d continuous groups separated by > %d hrs',length(i1), maxgap);	[i1 i2]else	i1=1;	i2=length(dt);end%==================% FIND ALL DATE POINTS INSIDE GROUPS% GROUPS ARE DEFINED BY [i1 i2]% DAY MARKS ARE DEFINED BY %==================idaymark=0;for i = 1 : length(i1),	ig = [i1(i):i2(i)]';	dtg=dt(ig);	% INDEX OF JDAYS IN THIS GROUP	ix=find( dtx >= dtg(1) & dtx <= dtg(end) )';	if length(ix)>0		idaymark = [idaymark; ix];	endendidaymark(1)=[];%======================% INTERPOLATE TO THE DAY MARKS%=====================if length(idaymark) > 0,	dty = dtx(idaymark);	laty=interp1(dt,lat,dty);	lony=interp1(dt,lon,dty);		%=============	% PLOT EACH DAY POINT	%=============	for j = 1:length(idaymark),		[yy,jj] = dt2jdf(dty(j));		str = sprintf('%03d', floor(jj));		tx = m_text(lony(j),laty(j), 'o', 'fontweight','bold','fontsize',10, 'color','black');		tx = m_text(lony(j),laty(j)+2*delx, str, 'fontweight','bold','fontsize',10, 'color','black');	endend% END POINTstr = 'END';tx = m_line(lon(end),lat(end)); set(tx,'marker','o','markerfacecolor','k','markeredgecolor','k');txstart = m_text(lon(end), lat(end)-delx, str, 'fontweight','bold','fontsize',10, 'color','black');set(txstart,'verticalalignment','top','horizontalalignment','center');str=sprintf('CRUISE %s, FROM %s TO %s',SERIES, dtstr(dt(1)), dtstr(dt(end)));title(str);set(gca,'fontname','helvetica','fontsize',14,'fontweight','bold');set(gca,'units','normalized','position',[0.05, 0.05, 0.8, 0.8]);return