'''
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
'''


from datetime import datetime
from math import log, exp, sqrt


# TL; DR
# the main learning process start at line 122


# parameters #################################################################

train = 'data/train.csv'  # path to training file
label = 'data/trainLabels.csv'  # path to label file of training data
test = 'data/test.csv'  # path to testing file

D = 2 ** 21 + 2 ** 19  # number of weights use for each model, we have 32 of them
alpha = .18   # learning rate for sgd optimization


# function, generator definitions ############################################

# A. x, y generator
# INPUT:
#     path: path to train.csv or test.csv
#     label_path: (optional) path to trainLabels.csv
# YIELDS:
#     ID: id of the instance (can also acts as instance count)
#     x: a list of indices that its value is 1
#     y: (if label_path is present) label value of y1 to y33
def data(nums,path, label_path=None):
    for t, line in enumerate(open(path)):
        # initialize our generator
    
        if t == 0:
            # create a static x,
            # so we don't have to construct a new x for every instance
            x = [0] * (146 + 46)
#            nums = [False] * (146 + 46)
            if label_path:
                label = open(label_path)
                label.readline()  # we don't need the headers
            continue
        # parse x
        row = line.rstrip().split(',')
        for m, feat in enumerate(row):
            if m == 0:
                ID = int(feat)
            elif (nums[m]):
                x[m] = float(feat)
#                if (t == 1):
#                    nums[m] = True
            else: 
                # one-hot encode everything with hash trick
                # categorical: one-hotted
                # boolean: ONE-HOTTED
                # numerical: ONE-HOTTED!
                # note, the build in hash(), although fast is not stable,
                #       i.e., same value won't always have the same hash
                #       on different machines
                x[m] = abs(hash(str(m) + '_' + feat)) % D
#        print str(nums)
        hash_cols = [3,4,34,35,61,64,65,91,94,95]
        tt = 146
        for i in xrange(10):
          for j in xrange(i+1,10):
            tt += 1
            x[tt] = abs(hash(row[hash_cols[i]]+"_x_"+row[hash_cols[j]])) % D
        
        # parse y, if provided
        if label_path:
            # use float() to prevent future type casting, [1:] to ignore id
            y = [float(y) for y in label.readline().split(',')[1:]]
        yield (ID, x, y) if label_path else (ID, x)


# B. Bounded logloss
# INPUT:
#     p: our prediction
#     y: real answer
# OUTPUT
#     bounded logarithmic loss of p given y
def logloss(p, y):
    p = max(min(p, 1. - 10e-15), 10e-15)
    return -log(p) if y == 1. else -log(1. - p)


# C. Get probability estimation on x
# INPUT:
#     x: features
#     w: weights
# OUTPUT:
#     probability of p(y = 1 | x; w)
def predict(x, w,nums):
    wTx = 0.
    for idx,i in enumerate(x):  # do wTx
        if (nums[idx]):
            wTx += w[0] * i  # w[i] * x[i], but if i in x we got x[i] = 1.
        else:
            wTx += w[i] * 1.  # w[i] * x[i], but if i in x we got x[i] = 1.
    return 1. / (1. + exp(-max(min(wTx, 20.), -20.)))  # bounded sigmoid

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

# D. Update given model
# INPUT:
# alpha: learning rate
#     w: weights
#     n: sum of previous absolute gradients for a given feature
#        this is used for adaptive learning rate
#     x: feature, a list of indices
#     p: prediction of our model
#     y: answer
# MODIFIES:
#     w: weights
#     n: sum of past absolute gradients
def update(alpha, w, n, x, p, y,nums):
    for idx,i in enumerate(x):
        # alpha / sqrt(n) is the adaptive learning rate
        # (p - y) * x[i] is the current gradient
        # note that in our case, if i in x then x[i] = 1.
        if (nums[idx]):
            n[0] += abs(p - y)
            w[0] -= (p - y) * i * alpha/sqrt(n[0])
        else:
            n[i] += abs(p - y)
            w[i] -= (p - y) * 1. * alpha / sqrt(n[i])


# training and testing #######################################################
start = datetime.now()

# a list for range(0, 33) - 13, no need to learn y14 since it is always 0
K = [k for k in range(33) if k != 13]

# initialize our model, all 32 of them, again ignoring y14
w = [[0.] * D if k != 13 else None for k in range(33)]
n = [[0.] * D if k != 13 else None for k in range(33)]

#nums = [5, 6, 7, 8, 9, 15, 16, 17, 18, 19, 20, 21, 22, 23, 27, 28, 29, 36, 37, 38, 39, 40, 46, 47, 48, 49, 50, 51, 52, 53, 54, 58, 59, 60, 66, 67, 68, 69, 70, 76, 77, 78, 79, 80, 81, 82, 83, 84, 88, 89, 90, 96, 97, 98, 99, 100, 106, 107, 108, 109, 110, 111, 112, 113, 114, 118, 119, 120, 121, 122, 123, 124, 125, 131, 132, 133, 134, 135, 136, 137, 138, 139, 143, 144, 145]
numsCol = [5,6,7,8,9,29,28,16,19,21,20]
#numsCol = [5, 6, 7, 8, 9, 15, 16, 17, 18, 19, 20, 21, 22, 23, 27, 28, 29, 36, 37, 38, 39, 40, 46, 47, 48, 49, 50, 51, 52, 53, 54, 58, 59, 60, 66, 67, 68, 69, 70, 76, 77, 78, 79, 80, 81, 82, 83, 84, 88, 89, 90, 96, 97, 98, 99, 100, 106, 107, 108, 109, 110, 111, 112, 113, 114, 118, 119, 120, 121, 122, 123, 124, 125, 131, 132, 133, 134, 135, 136, 137, 138, 139, 143, 144, 145]
#numsCol = [5,6,7,8,9,15, 16, 17, 18,19,21,28,29,36,37,38,39,40,47,50,52,59,60,66,67,68,69,70,77,80,82,89,90,96,97,98,99,100,107,110,112,119,120,121,122,123,124,125,132,135,137,144,145]
#nums = [False, False, False, False, False, True, True, True, True, True, False, False, False, False, False, True, True, True, True, True, True, True, True, True, False, False, False, True, True, True, False, False, False, False, False, False, True, True, True, True, True, False, False, False, False, False, True, True, True, True, True, True, True, True, True, False, False, False, True, True, True, False, False, False, False, False, True, True, True, True, True, False, False, False, False, False, True, True, True, True, True, True, True, True, True, False, False, False, True, True, True, False, False, False, False, False, True, True, True, True, True, False, False, False, False, False, True, True, True, True, True, True, True, True, True, False, False, False, True, True, True, True, True, True, True, True, False, False, False, False, False, True, True, True, True, True, True, True, True, True, False, False, False, True, True, True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
nums = [False] * 192
for k in numsCol:
    nums[k] = True



loss = 0.
loss_y14 = log(1. - 10**-15)

for ID, x, y in data(nums,train, label):

    # get predictions and train on all labels
    for k in K:
        p = predict(x, w[k],nums)
        update(alpha, w[k], n[k], x, p, y[k],nums)
        loss += logloss(p, y[k])  # for progressive validation
    loss += loss_y14  # the loss of y14, logloss is never zero

    # print out progress, so that we know everything is working
    if ID % 50000 == 0:
        print('%s\tencountered: %d\tcurrent logloss: %f' % (
            datetime.now(), ID, (loss/33.)/ID))

with open('./data/submission1234.csv', 'w') as outfile:
    outfile.write('id_label,pred\n')
    for ID, x in data(nums,test):
        for k in K:
            p = predict(x, w[k],nums)
            outfile.write('%s_y%d,%s\n' % (ID, k+1, str(p)))
            if k == 12:
                outfile.write('%s_y14,0.0\n' % ID)

print('Done, elapsed time: %s' % str(datetime.now() - start))
