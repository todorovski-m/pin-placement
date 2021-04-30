# Optimal Power Injection Placement in Radial Distribution Systems Using Clustering Optimisation

Nowadays, distributed generation plays a vital role in distribution systems. It makes an indisputable contribution towards power loss minimization and voltage profile improvement. In order to maximize the benefits of distributed generators, their location and size is of crucial importance. The code uses clustering optimisation as a highly effective method for determining the optimal placement and sizing of distributed generators.

Assessment of the effectiveness from the clustering optimisation method is achieved by its demonstration on a 69-bus and 119-bus distribution systems. Furthermore, the results obtained from implementation of the proposed approach are compared to results from recent studies including analytical approaches, heuristic and meta-heuristic, as well as mathematical programming algorithms.

It is concluded that clustering optimisation is a simple and efficient method in terms of optimal allocation and sizing of distributed generators. It outweighs other approaches in terms of simplicity, results and computation time.

`case69.m` and `case119.m` are input files that contains system data, size of the active, reactive or apparent power injection, type and number of locations, voltage constraints and objective function values coefficients.

`dg_clust_dp.m`  the main file to call upon that does the optimisation, for example `dg_clust_dp('case69')` which as an output produces text file named `dg_clust_dp.txt`.

All other `*.m` files are supplementary and have supportive role in data pre/post-processing and code organisation.
