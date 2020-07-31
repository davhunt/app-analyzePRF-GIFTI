function createSurfs(pial_L, pial_R, wm_L, wm_R, inflated_L, inflated_R, HCP)

lh_white = gifti(char(wm_L{1}));
rh_white = gifti(char(wm_R{1}));
lh_pial = gifti(char(pial_L{1}));
rh_pial = gifti(char(pial_R{1}));
lh_inflated = gifti(char(inflated_L{1}));
rh_inflated = gifti(char(inflated_R{1}));

if HCP
  if size(lh_white.vertices,1) == 32492
    lh_fsLR_fsaverage_reg = gifti('resample_fsaverage/fs_LR-deformed_to-fsaverage.L.sphere.32k_fs_LR.surf.gii');
    rh_fsLR_fsaverage_reg = gifti('resample_fsaverage/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii');

    lh_atlas = gifti('atlasroi/102816.L.atlasroi.32k_fs_LR.shape.gii');
    rh_atlas = gifti('atlasroi/102816.R.atlasroi.32k_fs_LR.shape.gii');
  elseif size(lh_white.vertices,1) == 59292
    lh_fsLR_fsaverage_reg = gifti('resample_fsaverage/fs_LR-deformed_to-fsaverage.L.sphere.59k_fs_LR.surf.gii');
    rh_fsLR_fsaverage_reg = gifti('resample_fsaverage/fs_LR-deformed_to-fsaverage.R.sphere.59k_fs_LR.surf.gii');

    lh_atlas = gifti('atlasroi/102816.L.atlasroi.59k_fs_LR.shape.gii');
    rh_atlas = gifti('atlasroi/102816.R.atlasroi.59k_fs_LR.shape.gii');
  else
    error('Surface data does not appear to be from HCP 32k (2mm) or 59k (1.6mm) datasets');
  end

  good_vertices_index = struct;
  good_faces_bool = struct; % not actually used
  new_vertices = struct;
  new_faces = struct;

  for hemi = {'lh' 'rh'}
    atlas = eval([char(hemi),'_atlas']);
    good_vertices_index.(char(hemi)) = [];
    for i=(1:size(atlas.cdata,1))
      if atlas.cdata(i,1) == 1
        idx = int2str(i);
        good_vertices_index.(char(hemi)) = [good_vertices_index.(char(hemi)), i];
      end
    end
    for surf = {'_fsLR_fsaverage_reg' '_white' '_inflated' '_pial'}
      new_vertices.([char(hemi),char(surf)]) = [];
      surfMesh = eval([char(hemi),char(surf)]);
      for i=(1:size(good_vertices_index.(char(hemi)),2))
        new_vertices.([char(hemi),char(surf)]) = [new_vertices.([char(hemi),char(surf)]); eval(['surfMesh.vertices(',int2str(good_vertices_index.(char(hemi))(i)),',:)'])];
      end
    end
  end
  for hemi = {'lh' 'rh'}
    surfMesh = eval([char(hemi),'_white']);
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
    for surf = {'_fsLR_fsaverage_reg' '_white' '_inflated' '_pial'}
      tmpgii = gifti;
      tmpgii.vertices = single(new_vertices.([char(hemi),char(surf)]));
      tmpgii.faces = int32(new_faces.(char(hemi)));
      tmpgii.mat = surfMesh.mat;
      if strcmp(char(surf),'_fsLR_fsaverage_reg')
        save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.sphere.reg.gii']);
      elseif strcmp(char(surf),'_white')
        save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.white.gii']);
      elseif strcmp(char(surf),'_inflated')
        save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.inflated.gii']);
      elseif strcmp(char(surf),'_pial')
        save_gifti(tmpgii,['./prf/surfaces/',char(hemi),'.pial.gii']);
      end
    end
  end
elseif ~HCP
  save_gifti(lh_white, './prf/surfaces/lh.white.gii');
  save_gifti(rh_white, './prf/surfaces/rh.white.gii');
  save_gifti(lh_inflated, './prf/surfaces/lh.inflated.gii');
  save_gifti(rh_inflated, './prf/surfaces/rh.inflated.gii');
  save_gifti(lh_pial, './prf/surfaces/lh.pial.gii');
  save_gifti(rh_pial, './prf/surfaces/rh.pial.gii');
end

end
