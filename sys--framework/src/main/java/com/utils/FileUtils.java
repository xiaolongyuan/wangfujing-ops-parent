package com.utils;


import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
/**
 * 说 明     : 文件处理工具类
 * author: 陆湘星
 * data  : 2011-5-28
 * email : xiangxingchina@163.com
 **/
public class FileUtils extends org.apache.commons.io.FileUtils {

	/**
	 * 输出文件到磁盘
	 * 
	 * @param data
	 * @param filePathAndName
	 * @throws Exception
	 */
	public static void writeFileToDisk(byte[] data, String filePath)
			throws Exception {
		// 文件输出流
		FileOutputStream fos = null;
		if (StringUtils.isNotEmpty(filePath) && null != data) {
			fos = new FileOutputStream(filePath);
			fos.write(data);
			fos.close();
		}
	}

	/**
	 * 获得文件byte[]
	 * 
	 * @param filePath
	 * @throws Exception
	 * @throws Exception
	 */
	public static byte[] readFileToByteArray(String filePath) throws Exception {
		File file = new File(filePath);
		InputStream in = new FileInputStream(file);
		try {
			return IOUtils.toByteArray(in);
		} finally {
			IOUtils.closeQuietly(in);
		}
	}

	/**
	 * 获得随机文件名
	 * 
	 * @param fileName
	 * @return
	 */
	public static String getUUIDName(String fileName) {
		String[] split = fileName.split("\\.");
		String extendFile = "" + split[(split.length - 1)].toLowerCase();
		return UUID.randomUUID().toString() + extendFile;
	}

	/**
	 * 获得随机文件ID
	 * 
	 * @param fileName
	 * @return
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString();
	}

	/**
	 * 获得文件名
	 * 
	 * @param fileName
	 * @return
	 */
	public static String getFileName(String fileName) {
		String[] split = fileName.split("\\.");
		return split[0];
	}

	/**
	 * 获得网络文件名（带扩展名）
	 * 
	 * @param fileName
	 * @return
	 */
	public static String getUrlFileName(String url) {
		return url.substring(url.lastIndexOf("/")+1);
	}

	/**
	 * 获得文件类型
	 * 
	 * @param fileName
	 * @return
	 */
	public static String getFileTypeByName(String fileName) {
		String[] split = fileName.split("\\.");
		String extendFile = split[(split.length - 1)].toLowerCase();
		return extendFile;
	}
	
	/**
	 * 创建文件
	 * 
	 * @param filePath 文件路径
	 * @param content 文件内容
	 * @param encoder 文件编码
	 * @return
	 */
	public static void createFileWithEncoder(String filePath, String content, String encoder) throws Exception{
		// 创建文件输出流
		FileOutputStream fos = new FileOutputStream(filePath, false);
		OutputStreamWriter osw = new OutputStreamWriter(fos, encoder);
		osw.write(content);
		// 关闭流
		osw.close();
		fos.close();
	}
	
	/**
	 * 创建目录
	 * 
	 * @param dirs 文件路径
	 * @return
	 */
	public static void createDirs(String dirs) throws Exception{
		File file = new File(dirs);
		if(!file.exists())	file.mkdirs();
	}
	
	/**
	 * 保存文件到指定路径
	 * @param f 文件
	 * @param path 路径
	 * @throws Exception 
	 */
	public static String save(File f, String path) throws Exception {		
		File dest = new File(path);
		if(!dest.getParentFile().exists())
			dest.getParentFile().mkdirs();
		FileUtils.copyFile(f, dest);
		return path;
	}
	
	/**
	 * 根据路径来删除文件
	 * @param path
	 * @throws IOException
	 */
	public static void delete(String path) throws Exception {
		File dest = new File(path);
		if(dest.exists()){
			FileUtils.forceDelete(dest);
		}
	}
	
	
	/**
	 * 根据路径来删除文件
	 * @param path
	 * @throws IOException
	 */
	public static void delete(File dest) throws Exception {
		if(dest.exists()){
			FileUtils.forceDelete(dest);
		}
	}
	
	/**
	 * 根据URL保存文件
	 * @param url 文件url
	 * @param filePath 文件保存路径
	 */
	public static void saveFileByUrl(String url, String filePath) throws Exception{
		// 创建网络连接
		HttpURLConnection httpUrl = ServletUtils.getHttpConnection(url);
		// 输入流
		BufferedInputStream bis = null;
		// 输出流
		FileOutputStream fos = null;
	    try {
	        bis = new BufferedInputStream(httpUrl.getInputStream());
	        FileUtils.delete(filePath);
	        fos = new FileOutputStream(new File(filePath),true);
	        byte[] buff = new byte[2048];
	        int bytesRead;
	        while(-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
	        	fos.write(buff,0,bytesRead);
	        }
	    }finally {
	    	// 关闭流
	        if (bis != null)
	            bis.close();
	        if (fos != null)
	        	fos.close();
	    }
	}
	
	/**
	 * 保存HTML片段中的图片到本地，并重设图片链接，返回HTML
	 * @param html 待解析的HTML
	 * @param savePath 图片保存路径
	 * @param newSavePath 图片保存处理后路径
	 * @throws Exception 
	 */
	public static String saveHtmlImgToLocal(String domain, String html, String savePath,String newSavePath,String uid){
		// 将HTML片段解析成文档
		Document doc = Jsoup.parse(html);
		// 获得所有图片
		Elements imgs = doc.getElementsByTag("img");
		
		//创建日期文件夹
		String ymd = DateUtils.formatDate2Str(DateUtils.DATE_PATTON_3);
		savePath += "/" + ymd;
		File dirFile = new File(savePath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}
		
		String imgName = "";
		String imgNewUrl = "";
		String regex = "^(http|https|ftp)+://.*$";
		for (int i=0;i<imgs.size();i++) {
			// 获得图片src属性
			String imgOldUrl = imgs.get(i).attr("src");
			if(Pattern.matches(regex, imgOldUrl) && !imgOldUrl.startsWith(domain)){
				// 获得随机文件名
				imgName = FileUtils.getUUIDName(FileUtils.getUrlFileName(imgOldUrl));
				// 保存图片
				try {
					FileUtils.saveFileByUrl(imgOldUrl, savePath + "/" + imgName);
					imgNewUrl = domain + newSavePath+"/"+ymd+"/"+imgName;
					doc.getElementsByTag("img").get(i).attr("src", imgNewUrl);
				} catch (Exception e) {
					continue;
				}
			}
		}
		return doc.html();
	}
	
	
	/** 
	 *  新建目录  可建立多级目录
	 *  @param  folderPath  String  如  c:/fqf/abc
	 *  @return  boolean 
	 */
	public static void newFolders(String folderPath) {
		String dir[];
		try {
			String filePath = folderPath;
			filePath = filePath.toString();
			java.io.File myFilePath = new java.io.File(filePath);
			if (!myFilePath.exists()) {
				myFilePath.mkdir();
			}
			dir = folderPath.replace('\\', '/').split("/");
			String basePath = "";
			for (int i = 0; i < dir.length; i++) {
				basePath += dir[i] + File.separator;
				File subFile = new File(basePath);
				if (subFile.exists() == false)
					subFile.mkdir();
			}
		} catch (Exception e) {
			System.out.println("新建目录操作出错");
			e.printStackTrace();
		}
	}
	
	/** 
	 *  新建文件 
	 *  @param  filePathAndName  String  文件路径及名称  如c:/fqf.txt 
	 *  @param  fileContent  String  文件内容 
	 *  @return  boolean 
	 */
	public static void newFile(String filePath,String fileName, String fileContent) {
		String filePathAndName = filePath;
		if (filePath.endsWith(File.separator)) {
			filePathAndName += fileName;
		} else {
			filePathAndName +=File.separator+ fileName;
		}
		File f = new File(filePath);
        if(!f.exists()){
        f.mkdirs();
        }
		newFile(filePathAndName, fileContent);
	}
	
	/** 
	 *  新建文件 
	 *  @param  filePathAndName  String  文件路径及名称  如c:/fqf.txt 
	 *  @param  fileContent  String  文件内容 
	 *  @return  boolean 
	 */
	public static void newFile(String filePathAndName, String fileContent) {

		try {
			String filePath = filePathAndName;
			filePath = filePath.toString();
			File myFilePath = new File(filePath);
			if (!myFilePath.exists()) {
				myFilePath.createNewFile();
			}

			OutputStreamWriter out = new OutputStreamWriter(
			new FileOutputStream(myFilePath),"UTF-8");
            out.write(fileContent);
            out.flush();
            out.close(); 
					            
		} catch (Exception e) {
			System.out.println("新建文件操作出错");
			e.printStackTrace();

		}
	}
	
	/*
	 * 读取文件内容
	 */
	public static String GetFileContents(String filePath,String fileName){
//		StringBuffer buffer = new StringBuffer();
//		try {
//			File file = new File(filePath+File.separator+fileName);
//			if (file!=null && file.exists() && file.isFile()) {
//				BufferedReader input = new BufferedReader (new FileReader(file)); 
//	             String text; 
//	             while((text = input.readLine()) != null) {
//	                 buffer.append(text +"\n"); 
//				}
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return buffer.toString();
		File file = new File(filePath+File.separator+fileName);
		try {
			return FileUtils.readFileToString(file);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	   /** 
     *  移动文件到指定目录 
     *  @param  oldPath  String  如：c:/fqf.txt 
     *  @param  newPath  String  如：d:/fqf.txt 
	 * @throws Exception 
     */ 
   public  static void  moveFile(String  oldFile,  String  newFile) throws Exception  { 
       copyFile(oldFile,  newFile); 
       delFile(oldFile); 
   } 
   
   /** 
    *  复制单个文件 
    *  @param  oldPath  String  原文件路径  如：c:/fqf.txt 
    *  @param  newPath  String  复制后路径  如：f:/fqf.txt 
    *  @return  boolean 
 * @throws Exception 
    */ 
  public  static void  copyFile(String  oldFile,  String  newFile) throws Exception  { 
      try  { 
          int  bytesum  =  0; 
          int  byteread  =  0; 
          File  oldfile  =  new  File(oldFile); 
          if  (oldfile.exists())  {  //文件存在时 
              InputStream  inStream  =  new  FileInputStream(oldFile);  //读入原文件 
              FileOutputStream  fs  =  new  FileOutputStream(newFile); 
              byte[]  buffer  =  new  byte[1444]; 
              int  length; 
              while  (  (byteread  =  inStream.read(buffer))  !=  -1)  { 
                  bytesum  +=  byteread;  //字节数  文件大小 
                  fs.write(buffer,  0,  byteread); 
              } 
              fs.close();
              inStream.close(); 
          } 
      }catch  (Exception  e)  { 
    	  e.printStackTrace();
          throw new Exception("复制单个文件操作出错");
      } 
  } 
  
	  /** 
	   *  删除文件 
	   *  @param  filePathAndName  String  文件路径及名称  如c:/fqf.txt 
	   *  @param  fileContent  String 
	   *  @return  boolean 
	 * @throws Exception 
	   */ 
	 public  static void  delFile(String  filePathAndName) throws Exception  { 
	     try  { 
//	         String  filePath  =  filePathAndName; 
//	         filePath  =  filePath.toString(); 
//	         java.io.File  myDelFile  =  new  java.io.File(filePath); 
//	         myDelFile.delete(); 
//	         if (!myDelFile.delete()) {
//	        	 myDelFile.delete();
//	         }
	         delete(filePathAndName);
	     }catch  (Exception  e)  { 
	         System.out.println("删除文件操作出错"); 
	         e.printStackTrace();
	         throw new Exception("删除文件操作出错");
	     } 
	 } 
	 
	  /** 
	   *  查询文件列表 
	   *  @param  filePathAndName  String  文件路径及名称  如c:/fqf.txt 
	   *  @param  fileContent  String 
	   *  @return  boolean 
	   */ 
	public static List<String> queryFiles(String filePath) {
		ArrayList list = new ArrayList();
		File file = new File(filePath);
		if (!file.exists()) {
			return null;
		}
		if (!file.isDirectory()) {
			return null;
		}
		String[] tempList = file.list();
		for (int i = 0; i < tempList.length; i++) {
//			list.add(filePath + "/" + tempList[i]);
			list.add(tempList[i].trim());
		}
		return list;
	}
}