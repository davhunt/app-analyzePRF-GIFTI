function createSurfs(pial_L, pial_R, wm_L, wm_R, inflated_L, inflated_R)


lh_fsLR_fsaverage_reg = gifti('/N/u/davhunt/Carbonate/app-bayesian-retinotopy/resample_fsaverage/fs_LR-deformed_to-fsaverage.L.sphere.59k_fs_LR.surf.gii');
rh_fsLR_fsaverage_reg = gifti('/N/u/davhunt/Carbonate/app-bayesian-retinotopy/resample_fsaverage/fs_LR-deformed_to-fsaverage.R.sphere.59k_fs_LR.surf.gii');

lh_59k_atlas = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.L.atlasroi.59k_fs_LR.shape.gii');
rh_59k_atlas = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.R.atlasroi.59k_fs_LR.shape.gii');

%lh_59k_white = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.L.white_1.6mm_MSMAll.59k_fs_LR.surf.gii');
%rh_59k_white = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.R.white_1.6mm_MSMAll.59k_fs_LR.surf.gii');
% 59k GIFTIs in MNI space

%lh_59k_inflated = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.L.very_inflated_1.6mm_MSMAll.59k_fs_LR.surf.gii');
%rh_59k_inflated = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.R.very_inflated_1.6mm_MSMAll.59k_fs_LR.surf.gii');

%lh_59k_pial = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.L.pial_1.6mm_MSMAll.59k_fs_LR.surf.gii');
%rh_59k_pial = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.R.pial_1.6mm_MSMAll.59k_fs_LR.surf.gii');

%lh_59k_sphere = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.L.sphere.59k_fs_LR.surf.gii');
%rh_59k_sphere = gifti('/N/u/davhunt/Carbonate/Downloads/102816_hcp/102816_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/102816.R.sphere.59k_fs_LR.surf.gii');

lh_59k_white = gifti(wm_L);
rh_59k_white = gifti(wm_R);
lh_59k_pial = gifti(pial_L);
rh_59k_pial = gifti(pial_R);
lh_59k_inflated = gifti(inflated_L);
rh_59k_inflated = gifti(inflated_R);





%bad_vertices_index = struct;
good_vertices_index = struct;
good_faces_bool = struct; % not actually used
new_vertices = struct;
new_faces = struct;

for hemi = {'lh' 'rh'}
  atlas = eval([char(hemi),'_59k_atlas']);
  good_vertices_index.(char(hemi)) = [];
  for i=(1:size(atlas.cdata,1))
    if atlas.cdata(i,1) == 1
      idx = int2str(i);
      good_vertices_index.(char(hemi)) = [good_vertices_index.(char(hemi)), i];
    end
  end

  for surf = {'_fsLR_fsaverage_reg' '_59k_white' '_59k_inflated' '_59k_pial'}
    new_vertices.([char(hemi),char(surf)]) = [];
    surfMesh = eval([char(hemi),char(surf)]);
    
    for i=(1:size(good_vertices_index.(char(hemi)),2))
      new_vertices.([char(hemi),char(surf)]) = [new_vertices.([char(hemi),char(surf)]); eval(['surfMesh.vertices(',int2str(good_vertices_index.(char(hemi))(i)),',:)'])];
    end
  end
end

for hemi = {'lh' 'rh'}
  surfMesh = eval([char(hemi),'_59k_white']);
    new_faces.(char(hemi)) = [];
    good_faces_bool.(char(hemi)) = [];
    for i=(1:size(surfMesh.faces,1))
      if ismember(surfMesh.faces(i,1),good_vertices_index.(char(hemi))) && ismember(surfMesh.faces(i,2),good_vertices_index.(char(hemi))) && ismember(surfMesh.faces(i,3),good_vertices_index.(char(hemi)))

        good_faces_bool.(char(hemi)) = [good_faces_bool.(char(hemi)), 1];
        idx = int2str(i);
        new_faces.(char(hemi)) = [new_faces.(char(hemi)); eval(['surfMesh.faces(',idx,',:)'])];
      else
        good_faces_bool.(char(hemi)) = [good_faces_bool.(char(hemi)), 0];
      end
    end

    for i = (1:size(surfMesh.vertices,1))
      if ismember(i, good_vertices_index.(char(hemi)))
        new_faces.(char(hemi))(new_faces.(char(hemi)) == i) = find(good_vertices_index.(char(hemi)) == i);
      end
    end


  for surf = {'_fsLR_fsaverage_reg' '_59k_white' '_59k_inflated' '_59k_pial'}
%for surf = {'_fsLR_fsaverage_reg' '_59k_white'}
    tmpgii = gifti;
    tmpgii.vertices = single(new_vertices.([char(hemi),char(surf)]));
    tmpgii.faces = int32(new_faces.(char(hemi)));
    tmpgii.mat = surfMesh.mat;
    if strcmp(char(surf),'_fsLR_fsaverage_reg')
      save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.sphere.reg.gii']);
    elseif strcmp(char(surf),'_59k_white')
      save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.white.gii']);
    elseif strcmp(char(surf),'_59k_inflated')
      save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.inflated.gii']);
    elseif strcmp(char(surf),'_59k_pial')
      save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.pial.gii']);
%    elseif strcmp(char(surf),'_59k_sphere')
%      save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.sphere.gii']);
    end
  end
end

end
