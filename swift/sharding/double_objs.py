from swift.container.backend import ContainerBroker
broker = ContainerBroker('/srv/1/node/sdb3/containers/122/8cc/7a369ae647a78e'
                         '80995744973934e8cc/7a369ae647a78e80995744973934e'
                         '8cc_pivot.db')
#broker = ContainerBroker('/srv/1/node/sdb3/containers/122/8cc/7a369ae647a78e'
#                         '80995744973934e8cc/7a369ae647a78e80995744973934e'
#                         '8cc.db')
items = broker.list_objects_iter(10000, '', '', '', '')

more_items = []
for item in items:
    i = list(item)
    i[0] = '%d%s' % (0, i[0])
    i.append(0)
    more_items.append(i)

dlist = []
for item in more_items:
    dlist.append(broker._record_to_dict(item))

broker.merge_items(dlist)
