## Introduction

The whole low-orbit satellite modelling is based on published data from Telesat, Canada. Based on a summarization from [MIT](https://ieeexplore.ieee.org/document/9473799).

## Methodology

1. Execute `linkage_budget.m` where you can get the whole constellation and earth stations，the code will calculate linkage budget and get mapping matrix from three different dimensions.

2. Execute `more_linkage_budget.m` where you can get linkage budget of mutable targets like vehicles, aerocrafts, ships and missiles. 

3. Execute `select_modulation.m` where you can recify the mode of modulation/demodulation.

4. Execute `concatenate.m` where you can get real time LLA information, a critical parameter in antenna gain calculation.

5. Execute `graph3.m` where you can get global antenna gain.

6. Execute `acc.m` where you can get visible analysis.

## Appendix

For more information, please refer to [Wiki](https://github.com/SuperbTUM/Constellation-Modelling/wiki) (Chinese).
