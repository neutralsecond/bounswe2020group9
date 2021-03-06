from django.urls import path


from user.views import vendorProductListView
from .views import ProductDetailAPIView, ProductListAPIView, UserCommentAPIView, CommentsOfProductAPIView, \
    AddCommentAPIView, UpdateCommentAPIView, CategoryListAPIView, SearchAPIView, SearchAPIView2


urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('categories/', CategoryListAPIView.as_view(), name="category-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('comment/<int:pid>/<int:uid>/', UserCommentAPIView.as_view(), name="user-comment"),
    path('comment/<int:pid>/', CommentsOfProductAPIView.as_view(), name="get-all-comments"),
    path('comment/update/<int:id>/', UpdateCommentAPIView.as_view(), name="update-comment"),
    path('comment/', AddCommentAPIView.as_view(), name="add-comments"),
    path('vendor/<int:vendor_id>/', vendorProductListView.as_view(), name="vendor-products"),
    path('search/<str:filter_type>/<str:sort_type>/', SearchAPIView.as_view()),
    path('search2/<str:filter_type>/<str:sort_type>/', SearchAPIView2.as_view()),

]
