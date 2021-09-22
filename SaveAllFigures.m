function SaveAllFigures(filename)
ChildList = sort(get(0,'Children'));
for cnum = 1:length(ChildList)
if strncmp(get(ChildList(cnum),'Type'),'figure',6)
    save2word(filename,ChildList(cnum));
%saveas(ChildList(cnum), ['FigureSave', opt, '_', num2str(ChildList(cnum)), '.' filetype]);
end
end