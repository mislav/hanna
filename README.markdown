# Hanna -- a better RDoc template

Hanna is an RDoc template that scales. It's implemented in Haml, making it
clean and readable. It's built with simplicity, beauty and ease of browsing in
mind.

Author: [Mislav][]

## A work in progress

Hanna is far from done, but it is the first RDoc template that's actually
_maintainable_.  First thing I have done is converted the original HTML
template to Haml and Sass, cleaning up and removing the (ridiculous amount of)
duplication.

Also, the template fragments are now in _separate files_. You would have
fainted if you seen how it was before. (It's really no wonder why there are no
other RDoc templates around ... save one: [Allison][].)

Ultimately, I'd like to lose the frameset. Currently that is far from possible
because the whole RDoc HTML Generator is built for frames. Still, that is my
goal.

## You can help

Don't like something? Think you can design better? (You probably can.)

This is git. I welcome all submissions towards my goal.


[Mislav]: http://mislav.caboo.se/ "Mislav Marohnić"
[Allison]: http://blog.evanweaver.com/files/doc/fauna/allison/ "A modern, pretty RDoc template"
