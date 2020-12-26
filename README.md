# WISH

### [Project](https://yichengwu.github.io/WISH/) | [Paper](https://www.nature.com/articles/s41377-019-0154-x)

This repository contains Matlab implementation for the Nature LSA2019 paper 

**WISH: wavefront imaging sensor with high resolution** by [Yicheng Wu](http://yicheng.rice.edu), [Manoj Sharma](https://sites.google.com/view/manojsharmaresearch/home), and [Ashok Veeraraghavan](http://computationalimaging.rice.edu/team/ashok-veeraraghavan/).

The python implementation can be found [here](https://github.com/taladjidi/WISHpy).

![WISH](/WISH_illustration.png)


## How to use

Please clone this repo. The main file is named as `WISH.m`.

If you want to use our generated SLM patterns, please download them from [Google Drive](https://drive.google.com/file/d/1I7U96ATbZ9xBhGmgp4JwlNB9Xv28bCd-/view?usp=sharing) and put them to the same directory as the code.

The current version is implemented using Matlab GPU array (recommended). If you want to run the code with only CPU, you might need to delte the code for GPU selection `g = gpuDevice(1);` and GPU array conversion `gpuArray`.


## Citation
If you find this code useful, please cite our papers.
```
@article{wu2019wish,
  title={WISH: wavefront imaging sensor with high resolution},
  author={Wu, Yicheng and Sharma, Manoj Kumar and Veeraraghavan, Ashok},
  journal={Light: Science \& Applications},
  volume={8},
  number={1},
  pages={1--10},
  year={2019},
  publisher={Nature Publishing Group}
}
```


## Contributions
If you have any questions/comments/bug reports, feel free to open a github issue or pull a request or e-mail to the author Yicheng Wu (wuyichengg@gmail.edu).
