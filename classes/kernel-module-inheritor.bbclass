# this is a nasty hack for https://bugzilla.yoctoproject.org/show_bug.cgi?id=14124
# inherits more bbclass from ${MODULE_CLASSES} if module-base is inherited

def inheritor(name, d):
  fn = d.getVar('FILE')
  list = name.split() or []
  for l in list:
    bb.parse.BBHandler.inherit(l, fn, 0, d)

MODULE_CLASSES ??= ""

addhandler moduleclass_handler
python moduleclass_handler(){
  if bb.data.inherits_class('module-base', d):
    inheritor(d.getVar('MODULE_CLASSES'),d)
}
moduleclass_handler[eventmask] = "bb.event.RecipePreFinalise"
