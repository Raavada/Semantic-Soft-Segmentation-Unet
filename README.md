# Semantic-Soft-Segmentation-Unet

Semantic Soft Segmentation
Current techniques
for generating such representations depend heavily on interaction by a skilled visual artist, as creating
such accurate object selections .semantic soft segments, a set of layers that correspond to semantically
meaningful regions in an image with accurate soft transitions between different objects.
We approach this problem from a spectral segmentation angle and propose a graph structure that
embeds texture and color features from the image as well as higher-level semantic information generated
by a neural network. We design a graph structure that reveals the semantic objects as well as the soft
transitions between them in the eigenvectors of the corresponding Laplacian matrix The soft segments
are generated via eigendecomposition of the carefully constructed Laplacian matrix fully automatically
First of all, such a segmentation should provide distinct segments of the image, while also
representing the soft transitions between them accurately. In order to allow targeted
edits, each segment should be limited to the extent of a semantically meaningful region in the
image, e.g., it should not extend across the boundary between two objects. Finally, the
segmentation should be done fully automatically not to add a point of interaction or require
expertise from the artist.
The previous approaches for semantic segmentation, image matting, or soft color
segmentation fail to satisfy at least one of these qualities.
Semantic Soft Segmentation
For an input image, we generate per-pixel hyperdimensional semantic feature vectors and define a graph
using the texture and semantic information. The graph is constructed such that the corresponding
Laplacian matrix and its eigenvectors reveal the semantic objects and the soft transitions between them.
We use the eigenvectors to create a set of preliminary soft segments and combine them to get
semantically meaningful segments. Finally, we refine the soft segments so that they can be used for
targeted image editing tasks.

This method uses
The affinity-based methods, such as closed-form matting [Levin et al. 2008a], KNN matting
[Chen et al. 2013], and information-flow matting [Aksoy et al. 2017a], define inter-pixel
affinities to construct a graph that reflects the opacity transitions in the image.
The core component of this approach is the creation of a Laplacian matrix L that represents
how likely each pair of pixels in the image is to belong to the same segment
Spectral matting. They first introduced the matting Laplacian that uses local color
distributions to define a matrix L that captures the affinity between each pair of pixels.This
formulation shows that the eigenvectors associated to small eigenvalues of L play an
important role in the creation of high-quality mattes.Motivated by
this observation, they used eigenvectors of L to build a soft segmentation
Affinity Pairs with a positive affinity are more likely to have similar values, zero-affinity
pairs are independent, and pairs with a negative affinity are likely to have different values.

Nonlocal Color Affinity

We propose a guided sampling based on an oversegmentation of the image. We
generate 2500 superpixels using SLIC [Achanta et al. 2012] and estimate the
affinity between each superpixel and all the superpixels within a radius that
corresponds to 20% of the image size.(background scene seen through a hole

High-Level Semantic Affinity

To create segments that are confined in semantically similar regions, we add a semantic
affinityWe define the semantic affinity also over superpixels. In addition to increasing the
sparsity of the linear system, the use of superpixels also decrease the negative effect of the
unreliable feature vectors in transition regions, as apparent from their blurred appearance
Unlike the color affinity, the semantic affinity only relates nearby superpixels to favor the
creation of connected objects. This choice of a color affinity together with a local semantic
affinity allows nonlocal creating layers that can cover spatially disconnected regions of the
same semantically coherent region.

Constrained sparsification

We extract the eigenvectors corresponding to the 100 smallest eigenvalues of L we use
k-means clustering on the pixels represented by their feature vectors .We have set the
number of segments to 5 (K=5)without loss of generalization; while this number could be set
by the user depending on the scene structure, we have observed that it is a reasonable number
for most images.
Relaxed sparsification.
We define an energy function that promotes matte sparsity on the pixel-level while respecting
the initial soft segment estimates from the constrained sparsification and the image structure.
Energy function
E = EL + ES + EF + λEC .

Semantic Feature Vectors

In our implementation, we have combined a semantic segmentation approach with
a network for metric learning. The base network of our feature extractor is based
on DeepLab- ResNet-101 but it is trained with a metric learning approach [Hoffer and
Ailon 2015] to maximize the L2 distance between the features of different objects. We
combine features essentially combining the mid-level and high-level features together.
Since we only use this cue, i.e. whether two pixels belong to the same category or not, specific
object category information is not used during training. Hence, our method is a class agnostic
approach. This is suitable for our overall goal of semantic soft segmentation as we aim to
create soft segments that cover semantic objects, rather than classification of the objects in
an image.

EXPERIMENTAL ANALYSIS

Semantic soft segmentation, being at the intersection of semantic segmentation, natural
image matting, and soft segmentation, is challenging to evaluate numerically.
It should be noted that it is not uncommon for our method to represent the same object in
multiple segments such as the horse carriage  or the background fence in . 
This is mainly due to the preset number of layers, five, sometimes exceeds the number
of meaningful regions in the image Some smallobjects may be missed in the final segments
despite being detectedby the semantic features,
such the people in the background . This is due to the fact that, especially when
the color of the object is similar to the surroundings, the objects do not appear well-defined
in the eigenvectors and they end up being merged into closeby segments.
Our semantic features are not instance-aware, i.e. the features of two different objects of the
same class are similar.
our method can succesfully leverage the semantic information for soft segmentation of a
grayscale image

Using Semantic Soft Segments for Image Editing

We demonstrate several use cases of our soft segments for targeted image editing
and compositing

LIMITATIONS AND FUTURE WORK

While we are able to generate accurate soft segmentations of images,in our prototype
implementation our solvers are not optimized for speed. As a result, our runtime for a 640
× 480 image lies between 3 and 4 minutes.
Our method does not generate separate layers for different in stances of the same class of
objects. This is due to our feature vectors, which does not provide instance-aware semantic
information

CONCLUSION

We have proposed a method that generates soft segments that correspond to semantically
meaningful regions in the image by fusing the high-level information from a neural network
with low-level image features fully automatically. We have shown that by carefully defining
affinities between different regions in the image, the soft segments with the semantic
boundaries can be revealed by spectral analysis of the constructed Laplacian matrix. The
proposed relaxed sparsification method for the soft segments can generate accurate soft
transitions while also providing a sparse set of layers. We have demonstrated that while
semantic segmentation and spectral soft segmentation methods fail to provide layers that are
accurate enough for image editing tasks, our soft segments provide a convenient intermediate
image representation that makes several targeted image editing tasks trivial, which otherwise
require the manual labor of a skilled artist.
